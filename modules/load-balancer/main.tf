resource "google_compute_backend_service" "application" {
  health_checks = [google_compute_health_check.application.self_link]
  name          = "${var.prefix}application"

  backend {
    group = var.primary_cluster_endpoint_group_self_link

    balancing_mode = "RATE"
    description    = "The backend service for the TFE application."
    max_rate       = 1000
  }
  port_name   = "https"
  protocol    = "HTTPS"
  timeout_sec = 10
}

resource "google_compute_health_check" "application" {
  name = "${var.prefix}application-health-check"

  check_interval_sec = 5
  tcp_health_check {
    port = "443"
  }
  timeout_sec = 4
}

resource "google_compute_url_map" "main" {
  name = "${var.prefix}application"

  default_service = google_compute_backend_service.application.self_link
  description     = "The URL map for TFE."
}


resource "google_compute_target_https_proxy" "main" {
  name             = "${var.prefix}https"
  ssl_certificates = [var.ssl_certificate_self_link]
  url_map          = google_compute_url_map.main.self_link

  ssl_policy = var.ssl_policy_self_link
}

resource "google_compute_global_address" "application" {
  name = "${var.prefix}application"
}

resource "google_compute_global_forwarding_rule" "https" {
  name   = "${var.prefix}https"
  target = google_compute_target_https_proxy.main.self_link

  ip_address            = google_compute_global_address.application.address
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
}
