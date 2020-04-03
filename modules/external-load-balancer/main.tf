resource "google_compute_health_check" "application" {
  name = "${var.prefix}application"

  check_interval_sec = 5
  description        = "The TFE application health check."
  https_health_check {
    port         = var.vpc_application_tcp_port
    request_path = "/_health_check"
  }
  timeout_sec = 4
}

resource "google_compute_backend_service" "application" {
  health_checks = [google_compute_health_check.application.self_link]
  name          = "${var.prefix}application"

  backend {
    group = var.primaries_instance_group_self_link

    balancing_mode        = "RATE"
    description           = "The TFE primaries."
    max_rate_per_instance = 333
  }
  backend {
    group = var.secondaries_instance_group_manager_instance_group

    balancing_mode        = "RATE"
    description           = "The TFE secondaries."
    max_rate_per_instance = 333
  }
  port_name   = "application"
  protocol    = "HTTPS"
  timeout_sec = 10
}

resource "google_compute_url_map" "application" {
  name = "${var.prefix}application"

  default_service = google_compute_backend_service.application.self_link
  description     = "The TFE application URL map."
}

resource "google_compute_target_https_proxy" "application" {
  name             = "${var.prefix}application"
  ssl_certificates = [var.ssl_certificate_self_link]
  url_map          = google_compute_url_map.application.self_link

  description = "The target HTTPS proxy for TFE application traffic."
  ssl_policy  = var.ssl_policy_self_link
}

resource "google_compute_global_forwarding_rule" "application" {
  name   = "${var.prefix}application"
  target = google_compute_target_https_proxy.application.self_link

  description           = "The global forwarding rule for TFE application traffic."
  ip_address            = var.vpc_address
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.vpc_application_tcp_port
}
