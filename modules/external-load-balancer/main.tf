resource "google_compute_backend_service" "main" {
  health_checks = [google_compute_health_check.main.self_link]
  name          = "${var.prefix}application"

  backend {
    group = var.primary_cluster_instance_group_self_link

    balancing_mode        = "RATE"
    description           = "The TFE primary cluster group."
    max_rate_per_instance = 333
  }
  backend {
    group = var.secondary_cluster_instance_group_manager_instance_group

    balancing_mode        = "RATE"
    description           = "The TFE secondary cluster group."
    max_rate_per_instance = 333
  }
  port_name   = "https"
  protocol    = "HTTPS"
  timeout_sec = 10
}

resource "google_compute_health_check" "main" {
  name = "${var.prefix}application"

  check_interval_sec = 5
  description        = "The TFE application health check."
  tcp_health_check {
    port = 443
  }
  timeout_sec = 4
}

resource "google_compute_url_map" "main" {
  name = "${var.prefix}application"

  default_service = google_compute_backend_service.main.self_link
  description     = "The TFE application URL map."
}

resource "google_compute_target_https_proxy" "application" {
  name             = "${var.prefix}application"
  ssl_certificates = [var.ssl_certificate_self_link]
  url_map          = google_compute_url_map.main.self_link

  description = "The target HTTPS proxy for TFE application traffic."
  ssl_policy  = var.ssl_policy_self_link
}

resource "google_compute_global_address" "main" {
  name = "${var.prefix}application"

  description = "The global address of the TFE application."
}

resource "google_compute_global_forwarding_rule" "application" {
  name   = "${var.prefix}application"
  target = google_compute_target_https_proxy.application.self_link

  description           = "The global forwarding rule for TFE application traffic."
  ip_address            = google_compute_global_address.main.address
  load_balancing_scheme = "EXTERNAL"
  port_range            = 443
}

resource "google_compute_target_tcp_proxy" "replicated" {
  name            = "${var.prefix}replicated"
  backend_service = google_compute_backend_service.main.self_link

  description = "The target TCP proxy for TFE Replicated traffic."
}

resource "google_compute_global_forwarding_rule" "replicated" {
  name   = "${var.prefix}replicated"
  target = google_compute_target_tcp_proxy.replicated.self_link

  description           = "The global forwarding rule for TFE Replicated traffic."
  ip_address            = google_compute_global_address.main.address
  load_balancing_scheme = "EXTERNAL"
  port_range            = 8800
}
