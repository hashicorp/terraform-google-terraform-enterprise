locals {
  application_name       = "${var.prefix}external-application"
  install_dashboard_name = "${var.prefix}external-install-dashboard"
}

resource "google_compute_health_check" "application" {
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

resource "google_compute_backend_service" "application" {
  health_checks = [google_compute_health_check.application.self_link]
  name          = local.application_name

  dynamic "backend" {
    for_each = var.primaries_instance_groups_self_links
    content {
      group = backend.value

      balancing_mode        = "RATE"
      description           = "Some of the TFE primaries."
      max_rate_per_instance = 333
    }
  }
  backend {
    group = var.secondaries_instance_group_manager_instance_group

    balancing_mode        = "RATE"
    description           = "The TFE secondaries."
    max_rate_per_instance = 333
  }
  description           = "TFE application."
  load_balancing_scheme = "EXTERNAL"
  port_name             = "application"
  protocol              = "HTTPS"
  timeout_sec           = 10
}

resource "google_compute_url_map" "application" {
  default_service = google_compute_backend_service.application.self_link
  name            = local.application_name

  description = "TFE application requests."
}

resource "google_compute_managed_ssl_certificate" "application" {
  provider = google-beta

  description = "TFE application."
  managed {
    domains = [var.dns_fqdn]
  }
  name = local.application_name
  timeouts {
    create = "30m"
  }
}

resource "google_compute_ssl_policy" "application" {
  name = local.application_name

  description     = "TFE application."
  min_tls_version = "TLS_1_2"
  profile         = "RESTRICTED"
}

resource "google_compute_target_https_proxy" "application" {
  name             = local.application_name
  ssl_certificates = [google_compute_managed_ssl_certificate.application.self_link]
  url_map          = google_compute_url_map.application.self_link

  description = "TFE application traffic."
  ssl_policy  = google_compute_ssl_policy.application.self_link
}

resource "google_compute_global_forwarding_rule" "application" {
  provider = google-beta

  name   = local.application_name
  target = google_compute_target_https_proxy.application.self_link

  description = "The global forwarding rule for TFE application traffic."
  ip_address  = var.vpc_address
  ip_protocol = "TCP"
  # Beta
  labels                = var.labels
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.vpc_application_tcp_port
}

resource "google_compute_health_check" "install_dashboard" {
  provider = google-beta

  name = local.install_dashboard_name

  check_interval_sec = 5
  description        = "TFE install dashboard."
  # Beta
  log_config {
    enable = true
  }
  tcp_health_check {
    port = var.vpc_install_dashboard_tcp_port
  }
  timeout_sec = 4
}

resource "google_compute_backend_service" "install_dashboard" {
  health_checks = [google_compute_health_check.install_dashboard.self_link]
  name          = local.install_dashboard_name

  dynamic "backend" {
    for_each = var.primaries_instance_groups_self_links
    content {
      group = backend.value

      balancing_mode               = "CONNECTION"
      description                  = "A group of compute instances which comprises some of the TFE primaries."
      max_connections_per_instance = 10
    }
  }
  backend {
    group = var.secondaries_instance_group_manager_instance_group

    balancing_mode               = "CONNECTION"
    description                  = "A group of compute instances which comprises the TFE secondaries."
    max_connections_per_instance = 10
  }
  port_name   = "install-dashboard"
  protocol    = "TCP"
  timeout_sec = 300
}

resource "google_compute_target_tcp_proxy" "install_dashboard" {
  backend_service = google_compute_backend_service.install_dashboard.self_link
  name            = local.install_dashboard_name

  description = "The target TCP proxy for TFE install dashboard traffic."
}

resource "google_compute_global_forwarding_rule" "install_dashboard" {
  name   = local.install_dashboard_name
  target = google_compute_target_tcp_proxy.install_dashboard.self_link

  description           = "The global forwarding rule for TFE install dashboard traffic."
  ip_address            = var.vpc_address
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.vpc_install_dashboard_tcp_port
}
