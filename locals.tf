locals {
  disable_services_on_destroy = false

  active_active = var.node_count >= 2

  networking_module_enabled = length(module.networking) > 0
  network_self_link         = local.networking_module_enabled ? module.networking[0].network.self_link : var.network
  subnetwork_self_link      = local.networking_module_enabled ? module.networking[0].subnetwork.self_link : var.subnetwork

  redis = length(module.redis) > 0 ? module.redis[0] : {
    host     = ""
    password = ""
    port     = ""
  }

  common_fqdn = trimsuffix(var.fqdn, ".")
  # Ensure that the FQDN is in the fully qualified format that GCP expects.
  # Trimming and re-adding the suffix ensures that either format can be provided for var.fqdn.
  full_fqdn = "${local.common_fqdn}."

  private_load_balancing_enabled = length(google_compute_address.private) > 0
  lb_address = (
    local.private_load_balancing_enabled ? google_compute_address.private : google_compute_global_address.public
  )[0].address
  trusted_proxies = local.private_load_balancing_enabled ? compact([
    "${local.lb_address}/32",
    # Include IP address range of the reserve subnetwork for private load balancing
    local.networking_module_enabled ? module.networking[0].reserve_subnetwork.ip_cidr_range : null
    ]) : [
    "${local.lb_address}/32",
    # Include IP address ranges of the Google Front End service
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  hostname               = var.dns_create_record ? local.common_fqdn : local.lb_address
  base_url               = "https://${local.hostname}/"
  replicated_console_url = "https://${local.hostname}:8800/"
}
