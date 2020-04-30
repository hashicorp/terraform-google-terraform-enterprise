# Create a storage bucket in which application state will be stored.
module "storage" {
  source = "hashicorp/terraform-enterprise/google//modules/storage"

  prefix                = var.prefix
  service_account_email = var.service_account_storage_email

  labels = var.labels
}

# Create a PostgreSQL database in which application data will be stored.
module "postgresql" {
  source = "hashicorp/terraform-enterprise/google//modules/postgresql"

  prefix                = var.prefix
  vpc_address_name      = var.vpc_postgresql_address_name
  vpc_network_self_link = var.vpc_network_self_link

  labels = var.labels
}

# Generate the application configuration.
module "application" {
  source = "hashicorp/terraform-enterprise/google//modules/application"

  dns_fqdn                                = module.dns.fqdn
  postgresql_database_instance_address    = module.postgresql.database_instance.private_ip_address
  postgresql_database_name                = module.postgresql.database.name
  postgresql_user_name                    = module.postgresql.user.name
  postgresql_user_password                = module.postgresql.user.password
  service_account_storage_key_private_key = var.service_account_storage_key_private_key
  storage_bucket_name                     = module.storage.bucket.name
  storage_bucket_project                  = module.storage.bucket.project
}

# Generate the cloud-init configuration.
module "cloud_init" {
  source = "hashicorp/terraform-enterprise/google//modules/cloud-init"

  application_config                = module.application.config
  internal_load_balancer_in_address = module.internal_load_balancer.in_address.address
  license_file                      = var.cloud_init_license_file
  vpc_cluster_assistant_tcp_port    = var.vpc_cluster_assistant_tcp_port
  vpc_install_dashboard_tcp_port    = var.vpc_install_dashboard_tcp_port
  vpc_kubernetes_tcp_port           = var.vpc_kubernetes_tcp_port
}

# Create the primaries.
module "primaries" {
  source = "hashicorp/terraform-enterprise/google//modules/primaries"

  cloud_init_configs             = module.cloud_init.primaries_configs
  prefix                         = var.prefix
  service_account_email          = var.service_account_primaries_email
  vpc_application_tcp_port       = var.vpc_application_tcp_port
  vpc_install_dashboard_tcp_port = var.vpc_install_dashboard_tcp_port
  vpc_kubernetes_tcp_port        = var.vpc_kubernetes_tcp_port
  vpc_network_self_link          = var.vpc_network_self_link
  vpc_subnetwork_project         = var.vpc_subnetwork_project
  vpc_subnetwork_self_link       = var.vpc_subnetwork_self_link

  labels = var.labels
}

# Create the internal load balancer for the primaries.
module "internal_load_balancer" {
  source = "hashicorp/terraform-enterprise/google//modules/internal-load-balancer"

  prefix                               = var.prefix
  primaries_instance_groups_self_links = module.primaries.instance_groups[*].self_link
  service_account_email                = var.service_account_internal_load_balancer_email
  vpc_cluster_assistant_tcp_port       = var.vpc_cluster_assistant_tcp_port
  vpc_kubernetes_tcp_port              = var.vpc_kubernetes_tcp_port
  vpc_network_self_link                = var.vpc_network_self_link
  vpc_subnetwork_ip_cidr_range         = var.vpc_subnetwork_ip_cidr_range
  vpc_subnetwork_project               = var.vpc_subnetwork_project
  vpc_subnetwork_self_link             = var.vpc_subnetwork_self_link

  labels = var.labels
}

# Create the secondaries.
module "secondaries" {
  source = "hashicorp/terraform-enterprise/google//modules/secondaries"

  cloud_init_config              = module.cloud_init.secondaries_config
  prefix                         = var.prefix
  service_account_email          = var.service_account_secondaries_email
  vpc_application_tcp_port       = var.vpc_application_tcp_port
  vpc_kubernetes_tcp_port        = var.vpc_kubernetes_tcp_port
  vpc_network_self_link          = var.vpc_network_self_link
  vpc_install_dashboard_tcp_port = var.vpc_install_dashboard_tcp_port
  vpc_subnetwork_project         = var.vpc_subnetwork_project
  vpc_subnetwork_self_link       = var.vpc_subnetwork_self_link

  labels = var.labels
}

# Create an external load balancer which directs traffic to the primaries.
module "external_load_balancer" {
  source = "hashicorp/terraform-enterprise/google//modules/external-load-balancer"

  prefix                                            = var.prefix
  primaries_instance_groups_self_links              = module.primaries.instance_groups[*].self_link
  secondaries_instance_group_manager_instance_group = module.secondaries.instance_group_manager.instance_group
  ssl_certificate_self_link                         = module.ssl.certificate.self_link
  ssl_policy_self_link                              = module.ssl.policy.self_link
  vpc_address                                       = var.vpc_external_load_balancer_address
  vpc_application_tcp_port                          = var.vpc_application_tcp_port
  vpc_install_dashboard_tcp_port                    = var.vpc_install_dashboard_tcp_port
}

# Configures DNS entries for the load balancer.
module "dns" {
  source = "hashicorp/terraform-enterprise/google//modules/dns"

  managed_zone                       = var.dns_managed_zone
  managed_zone_dns_name              = var.dns_managed_zone_dns_name
  vpc_external_load_balancer_address = var.vpc_external_load_balancer_address
}

# Create an SSL certificate to be attached to the external load balancer.
module "ssl" {
  source = "hashicorp/terraform-enterprise/google//modules/ssl"

  dns_fqdn = module.dns.fqdn
  prefix   = var.prefix
}
