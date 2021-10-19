resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = local.disable_services_on_destroy
}

resource "google_project_service" "cloudapi" {
  service            = "cloudapis.googleapis.com"
  disable_on_destroy = local.disable_services_on_destroy
}

resource "google_project_service" "servicenetworking" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = local.disable_services_on_destroy
}

resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = local.disable_services_on_destroy
}

resource "google_project_service" "redis" {
  service            = "redis.googleapis.com"
  disable_on_destroy = local.disable_services_on_destroy
}

module "object_storage" {
  source = "./modules/object_storage"

  namespace = var.namespace
  labels    = var.labels
}

module "service_accounts" {
  source = "./modules/service_accounts"

  bucket                 = module.object_storage.bucket
  ca_certificate_secret  = var.ca_certificate_secret
  license_secret         = var.license_secret
  namespace              = var.namespace
  ssl_certificate_secret = var.ssl_certificate_secret
  ssl_private_key_secret = var.ssl_private_key_secret
}

module "networking" {
  source = "./modules/networking"

  count = var.network == null ? 1 : 0

  active_active        = local.active_active
  namespace            = var.namespace
  subnet_range         = var.networking_subnet_range
  reserve_subnet_range = var.networking_reserve_subnet_range
  firewall_ports       = var.networking_firewall_ports
  healthcheck_ips      = var.networking_healthcheck_ips
  service_account      = module.service_accounts.email
  ip_allow_list        = var.networking_ip_allow_list
  ssh_source_ranges    = var.ssh_source_ranges
}

module "database" {
  source = "./modules/database"

  dbname            = var.database_name
  username          = var.database_user
  machine_type      = var.database_machine_type
  disk_size         = var.postgres_disk_size
  availability_type = var.database_availability_type
  namespace         = var.namespace
  backup_start_time = var.database_backup_start_time
  labels            = var.labels
  network           = local.network_self_link
  postgres_version  = var.postgres_version
}

module "redis" {
  source = "./modules/redis"
  count  = local.active_active ? 1 : 0

  auth_enabled = var.redis_auth_enabled
  namespace    = var.namespace
  memory_size  = var.redis_memory_size
  network      = local.network_self_link
  labels       = var.labels
}

module "user_data" {
  source = "./modules/user_data"

  airgap_url                = var.airgap_url
  ca_certificate_secret     = var.ca_certificate_secret
  ca_certs                  = var.ca_certs
  capacity_concurrency      = var.capacity_concurrency
  capacity_memory           = var.capacity_memory
  custom_image_tag          = var.custom_image_tag
  disk_path                 = var.disk_path
  enable_metrics_collection = var.enable_metrics_collection
  extra_no_proxy            = var.extra_no_proxy
  fqdn                      = local.common_fqdn
  gcs_bucket                = module.object_storage.bucket
  gcs_credentials           = module.service_accounts.credentials
  gcs_project               = module.object_storage.project
  hairpin_addressing        = var.hairpin_addressing
  license_secret            = var.license_secret
  monitoring_enabled        = var.monitoring_enabled
  pg_netloc                 = module.database.netloc
  pg_dbname                 = module.database.dbname
  pg_user                   = module.database.user
  pg_password               = module.database.password
  pg_extra_params           = "sslmode=require"
  redis_host                = local.redis.host
  redis_pass                = local.redis.password
  redis_port                = local.redis.port
  redis_use_password_auth   = var.redis_auth_enabled
  redis_use_tls             = var.redis_use_tls
  release_sequence          = var.release_sequence
  active_active             = local.active_active
  proxy_ip                  = var.proxy_ip
  namespace                 = var.namespace
  no_proxy                  = [local.common_fqdn, var.networking_subnet_range]
  iact_subnet_list          = var.iact_subnet_list
  iact_subnet_time_limit    = var.iact_subnet_time_limit
  ssl_certificate_secret    = var.ssl_certificate_secret
  ssl_private_key_secret    = var.ssl_private_key_secret
  tbw_image                 = var.tbw_image
  tls_vers                  = var.tls_vers
  trusted_proxies = concat(
    var.trusted_proxies,
    local.trusted_proxies
  )
}

module "vm_instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 7.1"

  name_prefix = "${var.namespace}-tfe-template-"

  additional_disks = [
    {
      auto_delete  = true
      boot         = false
      device_name  = local.disk_device_name
      disk_labels  = var.labels
      disk_name    = "tfe-mounted"
      disk_size_gb = 40
      disk_type    = "pd-ssd"
      mode         = "READ_WRITE"
    }
  ]
  auto_delete    = true
  can_ip_forward = true
  disk_labels    = var.labels
  disk_type      = var.vm_disk_type
  disk_size_gb   = var.vm_disk_size
  labels         = var.labels
  machine_type   = var.vm_machine_type
  service_account = {
    scopes = ["cloud-platform"]

    email = module.service_accounts.email
  }
  source_image   = var.vm_disk_source_image
  startup_script = module.user_data.script
  subnetwork     = local.subnetwork_self_link
}

module "vm_mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 7.1"

  instance_template = module.vm_instance_template.self_link
  region            = null

  health_check = {
    check_interval_sec  = 60
    healthy_threshold   = 2
    host                = null
    initial_delay_sec   = 600
    port                = 443
    proxy_header        = null
    request             = null
    request_path        = "/_health_check"
    response            = null
    timeout_sec         = 10
    type                = "https"
    unhealthy_threshold = 6
  }
  health_check_name = "${var.namespace}-tfe-health-check"
  hostname          = "${var.namespace}-tfe"
  named_ports = concat(
    [{
      name = "https"
      port = 443
    }],
    (
      local.enable_active_active ? [] : [{
        name = "console"
        port = 8800
      }]
    )
  )
  target_size = var.node_count
}

resource "google_compute_address" "private" {
  count = var.load_balancer != "PUBLIC" ? 1 : 0

  name         = "${var.namespace}-tfe-private-lb"
  subnetwork   = local.subnetwork_self_link
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
}

module "private_load_balancer" {
  count  = var.load_balancer == "PRIVATE" ? 1 : 0
  source = "./modules/private_load_balancer"

  namespace            = var.namespace
  fqdn                 = local.full_fqdn
  instance_group       = module.vm_mig.instance_group
  ssl_certificate_name = var.ssl_certificate_name
  dns_zone_name        = var.dns_zone_name
  subnetwork           = local.subnetwork_self_link
  dns_create_record    = var.dns_create_record
  ip_address           = google_compute_address.private[0].address
}

module "private_tcp_load_balancer" {
  count  = var.load_balancer == "PRIVATE_TCP" ? 1 : 0
  source = "./modules/private_tcp_load_balancer"

  namespace         = var.namespace
  fqdn              = local.full_fqdn
  instance_group    = module.vm_mig.instance_group
  dns_zone_name     = var.dns_zone_name
  subnetwork        = local.subnetwork_self_link
  dns_create_record = var.dns_create_record
  ip_address        = google_compute_address.private[0].address
}


resource "google_compute_global_address" "public" {
  count = var.load_balancer == "PUBLIC" ? 1 : 0

  name = "${var.namespace}-tfe-public-lb"

  description = "The global address of the public load balancer for TFE."
}

module "load_balancer" {
  count  = var.load_balancer == "PUBLIC" ? 1 : 0
  source = "./modules/load_balancer"

  namespace            = var.namespace
  fqdn                 = local.full_fqdn
  instance_group       = module.vm_mig.instance_group
  ssl_certificate_name = var.ssl_certificate_name
  dns_zone_name        = var.dns_zone_name
  dns_create_record    = var.dns_create_record
  ip_address           = google_compute_global_address.public[0].address
}
