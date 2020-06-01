locals {
  application_name = "${var.prefix}private-application"
}

resource "google_compute_region_health_check" "application" {
  provider = google-beta

  name = local.application_name

  check_interval_sec = 5
  description        = "TFE application."
  https_health_check {
    port         = var.vpc_application_tcp_port
    request_path = "/_health_check"
  }
  # Beta
  log_config {
    enable = true
  }
  timeout_sec = 4
}

resource "google_compute_region_backend_service" "application" {
  health_checks = [google_compute_region_health_check.application.self_link]
  name          = local.application_name

  dynamic "backend" {
    for_each = var.primaries_instance_groups_self_links
    content {
      group = backend.value

      balancing_mode        = "RATE"
      capacity_scaler       = 1.0
      description           = "Some of the TFE primaries."
      max_rate_per_instance = 333
    }
  }
  backend {
    group = var.secondaries_instance_group_manager_instance_group

    balancing_mode        = "RATE"
    capacity_scaler       = 1.0
    description           = "The TFE secondaries."
    max_rate_per_instance = 333
  }
  description           = "TFE application."
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_name             = "application"
  protocol              = "HTTPS"
  timeout_sec           = 10
}

resource "google_compute_region_url_map" "application" {
  name = local.application_name

  default_service = google_compute_region_backend_service.application.self_link
  description     = "TFE application requests."
}

resource "google_compute_region_ssl_certificate" "application" {
  certificate = var.ssl_certificate
  private_key = var.ssl_certificate_private_key

  description = "TFE application."
  name_prefix = var.prefix
}

resource "google_compute_region_target_https_proxy" "application" {
  name             = local.application_name
  ssl_certificates = google_compute_region_ssl_certificate.application.self_link
  url_map          = google_compute_region_url_map.application.self_link

  description = "TFE application traffic."
}

resource "google_compute_address" "main" {
  provider = google-beta

  name = local.application_name

  address_type = "INTERNAL"
  description  = "TFE."
  # Beta
  labels     = var.labels
  purpose    = "GCE_ENDPOINT"
  subnetwork = var.vpc_subnetwork_self_link
}

resource "google_compute_forwarding_rule" "application" {
  provider = google-beta

  name = local.application_name

  description = "The forwarding rule for TFE application traffic."
  ip_address  = google_compute_address.main.address
  ip_protocol = "TCP"
  # Beta
  labels                = var.labels
  load_balancing_scheme = "INTERNAL_MANAGED"
  network               = var.vpc_network_self_link
  port_range            = var.vpc_application_tcp_port
  subnetwork            = var.vpc_subnetwork_self_link
  target                = google_compute_region_target_https_proxy.application.self_link
}
