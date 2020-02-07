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

module "app-config" {
  source = "./modules/external-config"

  gcs_bucket      = module.gcs.bucket_name
  gcs_project     = var.project
  gcs_credentials = module.service-account.credentials

  postgresql_address  = module.postgres.address
  postgresql_database = module.postgres.database_name
  postgresql_user     = module.postgres.user
  postgresql_password = module.postgres.password
}

module "common-config" {
  source = "./modules/common-config"

  services_config = module.app-config.services_config
  external_name   = module.dns.fqdn
}

module "cluster-config" {
  source = "./modules/configs"

  license_file         = var.license_file
  cluster_api_endpoint = module.proxy.address
  # Expand module.common-config to avoid a cycle on destroy
  # https://github.com/hashicorp/terraform/issues/21662#issuecomment-503206685
  common-config = {
    application_config = module.common-config.application_config,
    ca_certs           = module.common-config.ca_certs,
  }
}

# Configures the TFE cluster itself. Data is stored in the configured
# GCS bucket and Postgres Database.
module "cluster" {
  source     = "./modules/cluster"
  install_id = local.install_id
  prefix     = var.prefix

  project = var.project
  region  = var.region
  subnet  = module.vpc.subnet

  # Expand module.cluster-config to avoid a cycle on destroy
  # https://github.com/hashicorp/terraform/issues/21662#issuecomment-503206685
  cluster-config = {
    primary_cloudinit   = module.cluster-config.primary_cloudinit
    secondary_cloudinit = module.cluster-config.secondary_cloudinit
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

module "proxy" {
  source = "./modules/proxy"

  install_id = local.install_id
  primaries  = module.cluster.primaries.self_link
  region     = var.region
  subnet     = module.vpc.subnet

  prefix = var.prefix
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
