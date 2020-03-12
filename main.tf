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

module "external_config" {
  source = "./modules/external-config"

  gcs_bucket          = module.gcs.bucket.name
  gcs_credentials     = base64decode(module.service-account.credentials)
  gcs_project         = module.gcs.bucket.project
  postgresql_address  = module.postgres.address
  postgresql_database = module.postgres.database_name
  postgresql_password = module.postgres.password
  postgresql_user     = module.postgres.user
}

module "common_config" {
  source = "./modules/common-config"

  external_name = module.dns.fqdn
  services_config = {
    config       = module.external_config.services_config.config
    service_type = module.external_config.services_config.service_type
  }
}

module "configs" {
  source = "./modules/configs"

  cluster_api_endpoint = module.proxy.address
  common-config = {
    application_config = module.common_config.application_config
    ca_certs           = module.common_config.ca_certs
  }
  license_file = var.license_file
}

# Configures the TFE cluster itself. Data is stored in the configured
# GCS bucket and Postgres Database.
module "cluster" {
  source     = "./modules/cluster"
  install_id = local.install_id
  prefix     = var.prefix

  subnet = module.vpc.subnet

  cluster-config = {
    primary_cloudinit   = module.configs.primary_cloudinit
    secondary_cloudinit = module.configs.secondary_cloudinit
  }

  license_file = var.license_file

  access_fqdn = module.dns.fqdn

  gcs_bucket      = module.gcs.bucket.name
  gcs_credentials = module.service-account.credentials

  postgresql_address  = module.postgres.address
  postgresql_database = module.postgres.database_name
  postgresql_user     = module.postgres.user
  postgresql_password = module.postgres.password

  max_secondaries          = var.max_secondaries
  min_secondaries          = var.min_secondaries
  autoscaler_cpu_threshold = var.autoscaler_cpu_threshold
}

module "proxy" {
  source = "./modules/proxy"

  install_id               = local.install_id
  ip_cidr_range            = module.vpc.subnet.ip_cidr_range
  network                  = module.vpc.vpc_name
  primaries_instance_group = module.cluster.primaries.self_link
  subnetwork               = module.vpc.subnet.name
  subnetwork_project       = module.vpc.subnet.project

  prefix = var.prefix
}

# Configures DNS entries for the primaries as a convenience
module "dns-primaries" {
  source     = "./modules/dns-primaries"
  install_id = local.install_id
  prefix     = var.prefix

  dnszone   = var.dnszone
  primaries = module.cluster.primary_external_addresses
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

  cert           = module.ssl_certificate.certificate.self_link
  instance_group = module.cluster.application_endpoints
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
