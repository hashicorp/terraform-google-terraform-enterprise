# Create a storage bucket to store our critical application state into.
module "storage" {
  source = "./modules/storage"

  prefix = var.prefix
}

# Network creation:
# This section creates the various aspects of the networking required
# to run the cluster.

# Configure a Compute Network and Subnetwork to deploy resources into.
module "vpc" {
  source = "./modules/vpc"

  prefix = var.prefix
}

# Configure a firewall the network to allow access to cluster's ports.
module "firewall" {
  source = "./modules/firewall"

  prefix                       = var.prefix
  vpc_network_self_link        = module.vpc.network_url
  vpc_subnetwork_ip_cidr_range = module.vpc.subnet_ip_range
}

# Create a PostgreSQL database in which application data will be stored.
module "postgresql" {
  source = "./modules/postgresql"

  prefix                = var.prefix
  vpc_network_self_link = module.vpc.network_url
}

# Create a GCP service account to access our storage bucket
module "service-account" {
  source = "./modules/service-account"

  prefix = var.prefix
  bucket = module.storage.bucket.name
}

module "application" {
  source = "./modules/application"

  dns_fqdn                             = module.dns.fqdn
  postgresql_database_instance_address = module.postgresql.database_instance.first_ip_address
  postgresql_database_name             = module.postgresql.database.name
  postgresql_user_name                 = module.postgresql.user.name
  postgresql_user_password             = module.postgresql.user.password
  service_account_key_private_key      = module.service-account.credentials
  storage_bucket_project               = module.storage.bucket.project
  storage_bucket_self_link             = module.storage.bucket.self_link
}

module "cloud_init" {
  source = "./modules/cloud-init"

  application_config = module.application.config
  license_file       = var.cloud_init_license_file
  proxy_address      = module.proxy.address
}

# Configure the TFE primary cluster.
module "primary_cluster" {
  source = "./modules/primary-cluster"

  cloud_init_configs       = module.cloud_init.primary_configs
  prefix                   = var.prefix
  vpc_network_self_link    = module.vpc.network_url
  vpc_subnetwork_project   = module.vpc.subnet.project
  vpc_subnetwork_self_link = module.vpc.subnet.self_link
}

module "secondary_cluster" {
  source = "./modules/secondary-cluster"

  cloud_init_config        = module.cloud_init.secondary_config
  prefix                   = var.prefix
  vpc_network_self_link    = module.vpc.network_url
  vpc_subnetwork_project   = module.vpc.subnet.project
  vpc_subnetwork_self_link = module.vpc.subnet.self_link
}

module "proxy" {
  source = "./modules/proxy"

  ip_cidr_range            = module.vpc.subnet.ip_cidr_range
  network                  = module.vpc.vpc_name
  primaries_instance_group = module.primary_cluster.instance_group.self_link
  subnetwork               = module.vpc.subnet.name
  subnetwork_project       = module.vpc.subnet.project

  prefix = var.prefix
}

# Create an SSL certificate to be attached to the external load balancer.
module "ssl" {
  source = "./modules/ssl"

  dns_fqdn = module.dns.fqdn
  prefix   = var.prefix
}

# Configures a Load Balancer that directs traffic at the cluster's
# instance group
module "load_balancer" {
  source = "./modules/load-balancer"

  prefix                                   = var.prefix
  primary_cluster_endpoint_group_self_link = module.primary_cluster.endpoint_group.self_link
  ssl_certificate_self_link                = module.ssl.certificate.self_link
  ssl_policy_self_link                     = module.ssl.policy.self_link
}

# Configures DNS entries for the load balancer for cluster access
module "dns" {
  source = "./modules/dns"

  load_balancer_address = module.load_balancer.address
  managed_zone          = var.dns_managed_zone
  managed_zone_dns_name = var.dns_managed_zone_dns_name
}
