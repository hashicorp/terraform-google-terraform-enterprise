# Create a GCS bucket to store our critical application state into.
module "gcs" {
  source     = "./modules/gcs"
  install_id = local.install_id
  prefix     = var.prefix

  region = var.region
}

# Network creation:
# This section creates the various aspects of the networking required
# to run the cluster.

# Configure a Compute Network and Subnetwork to deploy resources into.
module "vpc" {
  source     = "./modules/vpc"
  install_id = local.install_id
  prefix     = var.prefix

  region = var.region
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
  bucket     = module.gcs.bucket_name
}

module "external_config" {
  source = "./modules/external-config"

  gcs_bucket          = module.gcs.bucket_name
  gcs_credentials     = base64decode(module.service-account.credentials)
  gcs_project         = var.project
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

  cluster_api_endpoint = module.cluster.cluster_api_endpoint
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

  project = var.project
  region  = var.region
  subnet  = module.vpc.subnet_name

  cluster-config = {
    primary_cloudinit   = module.configs.primary_cloudinit
    secondary_cloudinit = module.configs.secondary_cloudinit
  }

  license_file = var.license_file

  access_fqdn = module.dns.fqdn

  gcs_bucket      = module.gcs.bucket_name
  gcs_project     = var.project
  gcs_credentials = module.service-account.credentials

  postgresql_address  = module.postgres.address
  postgresql_database = module.postgres.database_name
  postgresql_user     = module.postgres.user
  postgresql_password = module.postgres.password

  max_secondaries          = var.max_secondaries
  min_secondaries          = var.min_secondaries
  autoscaler_cpu_threshold = var.autoscaler_cpu_threshold
}

# Configures DNS entries for the primaries as a convenience
module "dns-primaries" {
  source     = "./modules/dns-primaries"
  install_id = local.install_id
  prefix     = var.prefix

  project   = var.project
  dnszone   = var.dnszone
  primaries = module.cluster.primary_external_addresses
}

# Create a certificate to attach to the Load Balancer using the GCP Managed Certificate service
module "cert" {
  source     = "./modules/cert"
  install_id = local.install_id
  prefix     = var.prefix

  domain_name = module.dns.fqdn
}

# Configures a Load Balancer that directs traffic at the cluster's
# instance group
module "loadbalancer" {
  source     = "./modules/lb"
  install_id = local.install_id
  prefix     = var.prefix

  cert           = module.cert.certificate
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
