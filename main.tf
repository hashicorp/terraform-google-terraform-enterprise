locals {
  install_id = var.install_id != "" ? var.install_id : random_string.install_id.result
  prefix     = "${var.prefix}${local.install_id}-"
}

# Create a GCS bucket to store our critical application state into.
module "gcs" {
  source = "./modules/gcs"

  install_id = local.install_id

  prefix = var.prefix
}

# Network creation:
# This section creates the various aspects of the networking required
# to run the cluster.

# Configure a Compute Network and Subnetwork to deploy resources into.
module "vpc" {
  source = "./modules/vpc"

  install_id = local.install_id

  prefix = var.prefix
}

# Configure a firewall the network to allow access to cluster's ports.
module "firewall" {
  source     = "./modules/firewall"
  install_id = local.install_id
  prefix     = var.prefix

  vpc_name        = module.vpc.vpc_name
  subnet_ip_range = module.vpc.subnet_ip_range
}

# Create a CloudSQL Postgres database to use
module "postgres" {
  source     = "./modules/postgres"
  install_id = local.install_id
  prefix     = var.prefix

  network_url = module.vpc.network_url

  postgresql_availability_type = var.postgresql_availability_type
  postgresql_backup_start_time = var.postgresql_backup_start_time
}

# Create a GCP service account to access our GCS bucket
module "service-account" {
  source     = "./modules/service-account"
  install_id = local.install_id
  prefix     = var.prefix
  bucket     = module.gcs.bucket.name
}

module "application" {
  source = "./modules/application"

  dns_fqdn                             = module.dns.fqdn
  postgresql_database_instance_address = module.postgres.address
  postgresql_database_name             = module.postgres.database_name
  postgresql_user_name                 = module.postgres.user
  postgresql_user_password             = module.postgres.password
  service_account_key_private_key      = base64decode(module.service-account.credentials)
  storage_bucket_project               = module.gcs.bucket.project
  storage_bucket_name                  = module.gcs.bucket.name
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
  prefix                   = local.prefix
  vpc_network_self_link    = module.vpc.network_url
  vpc_subnetwork_project   = module.vpc.subnet.project
  vpc_subnetwork_self_link = module.vpc.subnet.self_link
}

module "secondary_cluster" {
  source = "./modules/secondary-cluster"

  cloud_init_config        = module.cloud_init.secondary_config
  prefix                   = local.prefix
  vpc_network_self_link    = module.vpc.network_url
  vpc_subnetwork_project   = module.vpc.subnet.project
  vpc_subnetwork_self_link = module.vpc.subnet.self_link
}

module "proxy" {
  source = "./modules/proxy"

  install_id               = local.install_id
  ip_cidr_range            = module.vpc.subnet.ip_cidr_range
  network                  = module.vpc.vpc_name
  primaries_instance_group = module.primary_cluster.instance_group.self_link
  subnetwork               = module.vpc.subnet.name
  subnetwork_project       = module.vpc.subnet.project

  prefix = var.prefix
}

# Configures DNS entries for the primaries as a convenience
module "dns-primaries" {
  source     = "./modules/dns-primaries"
  install_id = local.install_id
  prefix     = var.prefix

  dnszone = var.dnszone
  primaries = [for primary in module.primary_cluster.instances : {
    hostname = primary.name,
    address  = primary.network_interface.0.access_config.0.nat_ip,
  }]
}

# Create an SSL certificate to be attached to the external load balancer.
module "ssl" {
  source = "./modules/ssl"

  dns_fqdn = module.dns.fqdn
  prefix   = local.prefix
}

# Configures a Load Balancer that directs traffic at the cluster's
# instance group
module "loadbalancer" {
  source     = "./modules/lb"
  install_id = local.install_id
  prefix     = var.prefix

  cert           = module.ssl.certificate.self_link
  instance_group = module.primary_cluster.endpoint_group.self_link
}

# Configures DNS entries for the load balancer for cluster access
module "dns" {
  source     = "./modules/dns"
  install_id = local.install_id
  prefix     = var.prefix

  address  = module.loadbalancer.address
  dnszone  = var.dnszone
  hostname = var.hostname
}
