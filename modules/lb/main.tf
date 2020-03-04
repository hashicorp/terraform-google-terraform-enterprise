resource "google_compute_health_check" "application" {
  name = "${var.prefix}application-${var.install_id}"

  project = var.project

  check_interval_sec = 5
  description        = "The TFE application health check."
  https_health_check {
    port         = var.ports.application.tcp[0]
    request_path = "/session"
  }
  timeout_sec = 4
}

resource "google_compute_backend_service" "application" {
  health_checks = [google_compute_health_check.application.self_link]
  name          = "${var.prefix}application-${var.install_id}"

  project = var.project

  backend {
    group = var.primary_group

    balancing_mode        = "RATE"
    description           = "The TFE primary group."
    max_rate_per_instance = 333
  }
  backend {
    group = var.secondary_group

    balancing_mode        = "RATE"
    description           = "The TFE secondary group."
    max_rate_per_instance = 333
  }
  port_name   = "application"
  protocol    = "HTTPS"
  timeout_sec = 10
}

resource "google_compute_url_map" "application" {
  name = "${var.prefix}application-${var.install_id}"

  project = var.project

  default_service = google_compute_backend_service.application.self_link
  description     = "The TFE application URL map."
}

resource "google_compute_ssl_policy" "main" {
  count = var.ssl_policy == "" ? 1 : 0

  name = "${var.prefix}application-${var.install_id}"

  project = var.project

  description     = "The TFE application SSL policy."
  min_tls_version = "TLS_1_2"
  profile         = "RESTRICTED"
}

resource "google_compute_target_https_proxy" "application" {
  name             = "${var.prefix}application-${var.install_id}"
  ssl_certificates = [var.cert]
  url_map          = google_compute_url_map.application.self_link

  project = var.project

  description = "The target HTTPS proxy for TFE application traffic."
  ssl_policy  = var.ssl_policy != "" ? var.ssl_policy : google_compute_ssl_policy.main[0].self_link
}

resource "google_compute_global_forwarding_rule" "application" {
  name   = "${var.prefix}application-${var.install_id}"
  target = google_compute_target_https_proxy.application.self_link

  project = var.project

  description           = "The global forwarding rule for TFE application traffic."
  ip_address            = var.global_address
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.ports.application.tcp[0]
}
