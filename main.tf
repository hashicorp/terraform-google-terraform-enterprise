# Create service accounts which will be used to represent various components of the application.
module "service_account" {
  source = "./modules/service-account"

  prefix = var.prefix
}

# Create a storage bucket in which application state will be stored.
module "storage" {
  source = "./modules/storage"

  prefix                = var.prefix
  service_account_email = module.service_account.storage.email

  labels = var.labels
}

# Create a VPC with a network and a subnetwork to which resources will be attached.
module "vpc" {
  source = "./modules/vpc"

  prefix                                        = var.prefix
  service_account_primaries_load_balancer_email = module.service_account.primaries_load_balancer.email
  service_account_primaries_email               = module.service_account.primaries.email
  service_account_secondaries_email             = module.service_account.secondaries.email
}

# Create a PostgreSQL database in which application data will be stored.
module "postgresql" {
  source = "./modules/postgresql"

  prefix                = var.prefix
  vpc_address_name      = module.vpc.postgresql_address.name
  vpc_network_self_link = module.vpc.network.self_link

  labels = var.labels
}

# Generate the compute instance metadatas.
module "metadata" {
  source = "./modules/metadata"

  dns_fqdn                                = module.dns.fqdn
  license_url                             = var.license_url
  postgresql_database_instance_address    = module.postgresql.database_instance.private_ip_address
  postgresql_database_name                = module.postgresql.database.name
  postgresql_user_name                    = module.postgresql.user.name
  postgresql_user_password                = module.postgresql.user.password
  service_account_storage_key_private_key = module.service_account.storage_key.private_key
  storage_bucket_name                     = module.storage.bucket.name
  storage_bucket_project                  = module.storage.bucket.project
  vpc_cluster_assistant_tcp_port          = module.vpc.cluster_assistant_tcp_port
  vpc_install_dashboard_tcp_port          = module.vpc.install_dashboard_tcp_port
  vpc_kubernetes_tcp_port                 = module.vpc.kubernetes_tcp_port
  vpc_primaries_load_balancer_address     = module.vpc.primaries_load_balancer_address.address
}

# Create the primaries.
module "primaries" {
  source = "./modules/primaries"

  metadata                            = module.metadata.primaries
  prefix                              = var.prefix
  service_account_email               = module.service_account.primaries.email
  service_account_load_balancer_email = module.service_account.primaries_load_balancer.email
  vpc_address                         = module.vpc.primaries_address.address
  vpc_application_tcp_port            = module.vpc.application_tcp_port
  vpc_cluster_assistant_tcp_port      = module.vpc.cluster_assistant_tcp_port
  vpc_install_dashboard_tcp_port      = module.vpc.install_dashboard_tcp_port
  vpc_load_balancer_address           = module.vpc.primaries_load_balancer_address.address
  vpc_kubernetes_tcp_port             = module.vpc.kubernetes_tcp_port
  vpc_network_self_link               = module.vpc.network.self_link
  vpc_subnetwork_project              = module.vpc.subnetwork.project
  vpc_subnetwork_self_link            = module.vpc.subnetwork.self_link

  labels = var.labels
}

# Create the secondaries.
module "secondaries" {
  source = "./modules/secondaries"

  metadata                       = module.metadata.secondaries
  prefix                         = var.prefix
  service_account_email          = module.service_account.secondaries.email
  vpc_application_tcp_port       = module.vpc.application_tcp_port
  vpc_install_dashboard_tcp_port = module.vpc.install_dashboard_tcp_port
  vpc_kubernetes_tcp_port        = module.vpc.kubernetes_tcp_port
  vpc_network_self_link          = module.vpc.network.self_link
  vpc_subnetwork_project         = module.vpc.subnetwork.project
  vpc_subnetwork_self_link       = module.vpc.subnetwork.self_link

  labels        = var.labels
  max_instances = var.secondaries_max_instances
  min_instances = var.secondaries_min_instances
}

# Create an external load balancer which directs traffic to the primaries and to the secondaries.
module "external_load_balancer" {
  source = "./modules/external-load-balancer"

  dns_fqdn                                          = module.dns.fqdn
  prefix                                            = var.prefix
  primaries_instance_groups_self_links              = module.primaries.instance_groups[*].self_link
  secondaries_instance_group_manager_instance_group = module.secondaries.instance_group_manager.instance_group
  vpc_address                                       = module.vpc.external_load_balancer_address.address
  vpc_application_tcp_port                          = module.vpc.application_tcp_port
  vpc_install_dashboard_tcp_port                    = module.vpc.install_dashboard_tcp_port
}

# Configures DNS entries for the load balancer.
module "dns" {
  source = "./modules/dns"

  managed_zone                       = var.dns_managed_zone
  managed_zone_dns_name              = var.dns_managed_zone_dns_name
  vpc_external_load_balancer_address = module.vpc.external_load_balancer_address.address
}
