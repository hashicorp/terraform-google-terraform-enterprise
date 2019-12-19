resource "google_compute_backend_service" "application" {
  name        = "${var.prefix}application-${var.install_id}"
  port_name   = "https"
  protocol    = "HTTPS"
  timeout_sec = 10

  health_checks = [google_compute_health_check.application.self_link]

  backend {
    description    = "TFE Application"
    balancing_mode = "RATE"
    group          = var.instance_group
    max_rate       = 1000
  }
}

resource "google_compute_health_check" "application" {
  name               = "${var.prefix}application-healthcheck-${var.install_id}"
  check_interval_sec = 5
  timeout_sec        = 4

  tcp_health_check {
    port = "443"
  }
}

resource "google_compute_url_map" "tfe" {
  name        = "${var.prefix}urlmap-${var.install_id}"
  description = "Terraform Enterprise"

  default_service = google_compute_backend_service.application.self_link
}

resource "google_compute_ssl_policy" "default_policy" {
  name            = "${var.prefix}tfe-${var.install_id}"
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_target_https_proxy" "tfe" {
  name             = "${var.prefix}https-${var.install_id}"
  url_map          = google_compute_url_map.tfe.self_link
  ssl_certificates = [var.cert]
  ssl_policy       = var.ssl_policy != "" ? var.ssl_policy : google_compute_ssl_policy.default_policy.self_link
}

resource "google_compute_global_address" "application" {
  name = "${var.prefix}tfe-${var.install_id}"
}

resource "google_compute_global_forwarding_rule" "https" {
  name       = "${var.prefix}https-${var.install_id}"
  ip_address = google_compute_global_address.application.address
  target     = google_compute_target_https_proxy.tfe.self_link
  port_range = "443"

  load_balancing_scheme = "EXTERNAL"
}
