locals {
  install_id                                 = var.install_id != "" ? var.install_id : random_string.install_id.result
  prefix                                     = "${var.prefix}-${local.install_id}"
  rendered_dns_project                       = var.dns_project != "" ? var.dns_project : var.project
  storage_bucket_service_account_private_key = base64decode(module.service_accounts.storage_bucket_key.private_key)
}

# Create a default installation identifier to be joined with the prefix and prepended to the names of resources.
resource "random_string" "install_id" {
  length  = 8
  special = false
  upper   = false
}

# Create a storage bucket to store our critical application state into.
module "storage" {
  source = "./modules/storage"

  prefix                = local.prefix
  region                = var.region
  service_account_email = module.service_accounts.storage_bucket.email
}

# Network creation:
# This section creates the various aspects of the networking required
# to run the cluster.

# Configure a compute network and subnetwork to which resources will be attached.
module "vpc" {
  source = "./modules/vpc"

  prefix = local.prefix
  region = var.region
}

# Define the ports of the various services which make up the cluster.
module "ports" {
  source = "./modules/ports"
}

# Configure firewalls for the network to allow access to cluster's ports.
module "firewalls" {
  source = "./modules/firewalls"

  install_id                      = local.install_id
  ports                           = module.ports
  primary_service_account_email   = module.service_accounts.primary.email
  project                         = var.project
  proxy_service_account_email     = module.service_accounts.proxy.email
  secondary_service_account_email = module.service_accounts.secondary.email
  subnetwork_ip_cidr_range        = module.vpc.subnetwork.ip_cidr_range
  network_name                    = module.vpc.network.name

  prefix = var.prefix
}

# Create a CloudSQL Postgres database to use
module "postgres" {
  source     = "./modules/postgres"
  install_id = local.install_id
  prefix     = var.prefix

  network_self_link = module.vpc.network.self_link

  postgresql_availability_type = var.postgresql_availability_type
  postgresql_backup_start_time = var.postgresql_backup_start_time
}

# Create a GCP service account to access our storage bucket
module "service_accounts" {
  source = "./modules/service-accounts"

  install_id = local.install_id
  project    = var.project

  prefix = var.prefix
}

module "app-config" {
  source = "./modules/external-config"

  postgresql_address                         = module.postgres.address
  postgresql_database                        = module.postgres.database_name
  postgresql_password                        = module.postgres.password
  postgresql_user                            = module.postgres.user
  storage_bucket                             = module.storage.bucket
  storage_bucket_service_account_private_key = local.storage_bucket_service_account_private_key
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
  ports = module.ports
}

data "google_compute_zones" "available" {
  region = var.region

  status = "UP"
}

# Configures the TFE cluster itself. Data is stored in the configured
# storage bucket and Postgres Database.
module "cluster" {
  source = "./modules/cluster"

  access_fqdn = module.dns.fqdn
  # Expand module.cluster-config to avoid a cycle on destroy
  # https://github.com/hashicorp/terraform/issues/21662#issuecomment-503206685
  cluster-config = {
    primary_cloudinit   = module.cluster-config.primary_cloudinit
    secondary_cloudinit = module.cluster-config.secondary_cloudinit
  }
  install_id                      = local.install_id
  license_file                    = var.license_file
  ports                           = module.ports
  primary_service_account_email   = module.service_accounts.primary.email
  project                         = var.project
  secondary_service_account_email = module.service_accounts.secondary.email
  subnetwork                      = module.vpc.subnetwork

  autoscaler_cpu_threshold = var.autoscaler_cpu_threshold
  max_secondaries          = var.max_secondaries
  min_secondaries          = var.min_secondaries
  postgresql_address       = module.postgres.address
  postgresql_database      = module.postgres.database_name
  postgresql_password      = module.postgres.password
  postgresql_user          = module.postgres.user
  prefix                   = var.prefix
  region                   = var.region
  zone                     = data.google_compute_zones.available.names[0]
}

module "proxy" {
  source = "./modules/proxy"

  install_id             = local.install_id
  ports                  = module.ports
  primary_instance_group = module.cluster.primary_instance_group.self_link
  project                = var.project
  region                 = var.region
  service_account_email  = module.service_accounts.proxy.email
  subnetwork             = module.vpc.subnetwork

  prefix = var.prefix
}

# Configures DNS entries for the primaries as a convenience
module "dns-primaries" {
  source     = "./modules/dns-primaries"
  install_id = local.install_id
  prefix     = var.prefix

  project   = local.rendered_dns_project
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

module "global_address" {
  source = "./modules/global-address"

  install_id = local.install_id
  project    = var.project

  prefix = var.prefix
}

# Configures a Load Balancer that directs traffic at the cluster's
# instance group
module "loadbalancer" {
  source = "./modules/lb"

  cert            = module.cert.certificate
  global_address  = module.global_address.main.address
  install_id      = local.install_id
  ports           = module.ports
  primary_group   = module.cluster.primary_instance_group.self_link
  project         = var.project
  secondary_group = module.cluster.secondary_region_instance_group_manager.instance_group

  prefix = var.prefix
}

# Configures DNS entries for the load balancer for cluster access
module "dns" {
  source = "./modules/dns"

  address    = module.global_address.main.address
  dnszone    = var.dnszone
  hostname   = var.hostname
  install_id = local.install_id
  project    = local.rendered_dns_project

  prefix = var.prefix
}
