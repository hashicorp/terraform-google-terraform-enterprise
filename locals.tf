locals {
  disk_device_name              = "sdb"
  enable_active_active          = var.node_count >= 2
  enable_airgap                 = var.airgap_url == null && var.tfe_license_bootstrap_airgap_package_path != null
  enable_external               = var.operational_mode == "external" || local.enable_active_active
  enable_database_module        = local.enable_external
  enable_disk                   = var.operational_mode == "disk" && !local.enable_active_active
  enable_networking_module      = var.network == null
  enable_object_storage_module  = local.enable_external
  enable_redis_module           = local.enable_active_active
  service_networking_connection = try(module.networking[0].service_networking_connection, { network = var.network })
  subnetwork                    = try(module.networking[0].subnetwork, { self_link = var.subnetwork })

  redis = try(
    module.redis[0],
    {
      host            = null
      password        = null
      port            = null
      server_ca_certs = null
    }
  )

  common_fqdn = trimsuffix(var.fqdn, ".")
  # Ensure that the FQDN is in the fully qualified format that GCP expects.
  # Trimming and re-adding the suffix ensures that either format can be provided for var.fqdn.
  full_fqdn = "${local.common_fqdn}."

  private_load_balancing_enabled = length(google_compute_address.private) > 0
  lb_address                     = local.private_load_balancing_enabled ? google_compute_address.private[0].address : google_compute_global_address.public[0].address
  default_trusted_proxies = local.private_load_balancing_enabled ? compact([
    "${local.lb_address}/32",
    # Include IP address range of the reserve subnetwork for private load balancing
    try(module.networking[0].reserve_subnetwork.ip_cidr_range, null)
    ]) : [
    "${local.lb_address}/32",
    # Include IP address ranges of the Google Front End service
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
  trusted_proxies = concat(
    var.trusted_proxies,
    local.default_trusted_proxies
  )

  extra_no_proxy = var.distribution == "rhel" ? [
    ".subscription.rhn.redhat.com",
    ".cdn.redhat.com",
    ".akamaiedge.net",
    ".rhel.updates.googlecloud.com"
  ] : []

  hostname               = var.dns_create_record ? local.common_fqdn : local.lb_address
  base_url               = "https://${local.hostname}/"
  replicated_console_url = "https://${local.hostname}:8800/"

  object_storage = try(
    module.object_storage[0],
    {
      bucket  = null
      project = null
    }
  )

  database = try(
    module.database[0],
    {
      dbname   = null
      netloc   = null
      password = null
      user     = null
    }
  )
}
