# Create a storage bucket in which application state will be stored.
module "storage" {
  source = "./modules/storage"

  prefix                = var.prefix
  service_account_email = module.service_account.storage.email

  labels = var.labels
}

# Create a service account which will be used to access the storage bucket.
module "service_account" {
  source = "./modules/service-account"

  prefix              = var.prefix
  storage_bucket_name = module.storage.bucket.name
}

# Create a VPC with a network and a subnetwork to which resources will be attached.
module "vpc" {
  source = "./modules/vpc"

  prefix = var.prefix
}

# Create firewalls to control network traffic.
module "firewall" {
  source = "./modules/firewall"

  prefix                                  = var.prefix
  service_account_primary_cluster_email   = module.service_account.primary_cluster.email
  service_account_secondary_cluster_email = module.service_account.secondary_cluster.email
  vpc_network_self_link                   = module.vpc.network.self_link
  vpc_subnetwork_ip_cidr_range            = module.vpc.subnetwork.ip_cidr_range
}

# Create a PostgreSQL database in which application data will be stored.
module "postgresql" {
  source = "./modules/postgresql"

  prefix                = var.prefix
  vpc_network_self_link = module.vpc.network.self_link

  labels = var.labels
}

# Generate the application configuration.
module "application" {
  source = "./modules/application"

  dns_fqdn                                = module.dns.fqdn
  postgresql_database_instance_address    = module.postgresql.database_instance.first_ip_address
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

  application_config             = module.application.config
  license_file                   = var.cloud_init_license_file
  internal_load_balancer_address = module.internal_load_balancer.address.address
}

# Create the primary cluster.
module "primary_cluster" {
  source = "./modules/primary-cluster"

  cloud_init_configs       = module.cloud_init.primary_configs
  prefix                   = var.prefix
  service_account_email    = module.service_account.primary_cluster.email
  vpc_network_self_link    = module.vpc.network.self_link
  vpc_subnetwork_project   = module.vpc.subnetwork.project
  vpc_subnetwork_self_link = module.vpc.subnetwork.self_link

  labels = var.labels
}

# Create the primary cluster internal load balancer.
module "internal_load_balancer" {
  source = "./modules/internal-load-balancer"

  prefix                                   = var.prefix
  primary_cluster_instance_group_self_link = module.primary_cluster.instance_group.self_link
  vpc_network_self_link                    = module.vpc.network.self_link
  vpc_subnetwork_ip_cidr_range             = module.vpc.subnetwork.ip_cidr_range
  vpc_subnetwork_project                   = module.vpc.subnetwork.project
  vpc_subnetwork_self_link                 = module.vpc.subnetwork.self_link

  labels = var.labels
}

# Create the secondary cluster.
module "secondary_cluster" {
  source = "./modules/secondary-cluster"

  cloud_init_config        = module.cloud_init.secondary_config
  service_account_email    = module.service_account.secondary_cluster.email
  prefix                   = var.prefix
  vpc_network_self_link    = module.vpc.network.self_link
  vpc_subnetwork_project   = module.vpc.subnetwork.project
  vpc_subnetwork_self_link = module.vpc.subnetwork.self_link

  labels = var.labels
}

# Create an external load balancer which directs traffic to the primary cluster.
module "external_load_balancer" {
  source = "./modules/external-load-balancer"

  global_address                                          = module.global.address.address
  prefix                                                  = var.prefix
  primary_cluster_instance_group_self_link                = module.primary_cluster.instance_group.self_link
  secondary_cluster_instance_group_manager_instance_group = module.secondary_cluster.instance_group_manager.instance_group
  ssl_certificate_self_link                               = module.ssl.certificate.self_link
  ssl_policy_self_link                                    = module.ssl.policy.self_link
}

# Configures DNS entries for the load balancer.
module "dns" {
  source = "./modules/dns"

  global_address        = module.global.address.address
  managed_zone          = var.dns_managed_zone
  managed_zone_dns_name = var.dns_managed_zone_dns_name
}

# Create a global address to be attached to the external load balancer.
module "global" {
  source = "./modules/global"

  prefix = var.prefix
}

# Create an SSL certificate to be attached to the external load balancer.
module "ssl" {
  source = "./modules/ssl"

  dns_fqdn = module.dns.fqdn
  prefix   = var.prefix
}
