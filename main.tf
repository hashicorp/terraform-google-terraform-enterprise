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

  prefix                                       = var.prefix
  service_account_internal_load_balancer_email = module.service_account.internal_load_balancer.email
  service_account_primaries_email              = module.service_account.primaries.email
  service_account_secondaries_email            = module.service_account.secondaries.email
}

# Create a PostgreSQL database in which application data will be stored.
module "postgresql" {
  source = "./modules/postgresql"

  prefix                = var.prefix
  vpc_address_name      = module.vpc.postgresql_address.name
  vpc_network_self_link = module.vpc.network.self_link

  labels = var.labels
}

# Generate the application configuration.
module "application" {
  source = "./modules/application"

  dns_fqdn                                = module.dns.fqdn
  postgresql_database_instance_address    = module.postgresql.database_instance.private_ip_address
  postgresql_database_name                = module.postgresql.database.name
  postgresql_user_name                    = module.postgresql.user.name
  postgresql_user_password                = module.postgresql.user.password
  service_account_storage_key_private_key = module.service_account.storage_key.private_key
  storage_bucket_name                     = module.storage.bucket.name
  storage_bucket_project                  = module.storage.bucket.project
}

# Generate the cloud-init configuration.
module "cloud_init" {
  source = "./modules/cloud-init"

  application_config                = module.application.config
  internal_load_balancer_in_address = module.internal_load_balancer.in_address.address
  license_file                      = var.cloud_init_license_file
  vpc_cluster_assistant_tcp_port    = module.vpc.cluster_assistant_tcp_port
  vpc_install_dashboard_tcp_port    = module.vpc.install_dashboard_tcp_port
  vpc_kubernetes_tcp_port           = module.vpc.kubernetes_tcp_port
}

# Create the primaries.
module "primaries" {
  source = "./modules/primaries"

  cloud_init_configs             = module.cloud_init.primaries_configs
  prefix                         = var.prefix
  service_account_email          = module.service_account.primaries.email
  vpc_application_tcp_port       = module.vpc.application_tcp_port
  vpc_install_dashboard_tcp_port = module.vpc.install_dashboard_tcp_port
  vpc_kubernetes_tcp_port        = module.vpc.kubernetes_tcp_port
  vpc_network_self_link          = module.vpc.network.self_link
  vpc_subnetwork_project         = module.vpc.subnetwork.project
  vpc_subnetwork_self_link       = module.vpc.subnetwork.self_link

  labels = var.labels
}

# Create the internal load balancer for the primaries.
module "internal_load_balancer" {
  source = "./modules/internal-load-balancer"

  prefix                               = var.prefix
  primaries_instance_groups_self_links = module.primaries.instance_groups[*].self_link
  service_account_email                = module.service_account.internal_load_balancer.email
  vpc_cluster_assistant_tcp_port       = module.vpc.cluster_assistant_tcp_port
  vpc_kubernetes_tcp_port              = module.vpc.kubernetes_tcp_port
  vpc_network_self_link                = module.vpc.network.self_link
  vpc_subnetwork_ip_cidr_range         = module.vpc.subnetwork.ip_cidr_range
  vpc_subnetwork_project               = module.vpc.subnetwork.project
  vpc_subnetwork_self_link             = module.vpc.subnetwork.self_link

  labels = var.labels
}

# Create the secondaries.
module "secondaries" {
  source = "./modules/secondaries"

  cloud_init_config              = module.cloud_init.secondaries_config
  prefix                         = var.prefix
  service_account_email          = module.service_account.secondaries.email
  vpc_application_tcp_port       = module.vpc.application_tcp_port
  vpc_install_dashboard_tcp_port = module.vpc.install_dashboard_tcp_port
  vpc_kubernetes_tcp_port        = module.vpc.kubernetes_tcp_port
  vpc_network_self_link          = module.vpc.network.self_link
  vpc_subnetwork_project         = module.vpc.subnetwork.project
  vpc_subnetwork_self_link       = module.vpc.subnetwork.self_link

  labels = var.labels
}

# Create an external load balancer which directs traffic to the primaries.
module "external_load_balancer" {
  source = "./modules/external-load-balancer"

  prefix                                            = var.prefix
  primaries_instance_groups_self_links              = module.primaries.instance_groups[*].self_link
  secondaries_instance_group_manager_instance_group = module.secondaries.instance_group_manager.instance_group
  ssl_certificate_self_link                         = module.ssl.certificate.self_link
  ssl_policy_self_link                              = module.ssl.policy.self_link
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

# Create an SSL certificate to be attached to the external load balancer.
module "ssl" {
  source = "./modules/ssl"

  dns_fqdn = module.dns.fqdn
  prefix   = var.prefix
}
