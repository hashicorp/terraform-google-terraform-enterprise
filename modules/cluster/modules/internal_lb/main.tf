locals {
  ports            = ["80", "443", "6443", "23010"]
  healthcheck_port = 6443
}

resource "google_compute_address" "primaries" {
  name         = "${var.prefix}primaries-lb-${var.install_id}"
  address_type = "INTERNAL"
  subnetwork   = var.subnet.self_link
}

resource "google_compute_health_check" "cluster-api" {
  name = "${var.prefix}cluster-api-check-${var.install_id}"

  tcp_health_check {
    port = 6443
  }
}

resource "google_compute_region_backend_service" "primaries" {
  name          = "${var.prefix}primaries-lb-${var.install_id}"
  protocol      = "TCP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.cluster-api.self_link]

  backend {
    group = var.primaries
  }
}

resource "google_compute_forwarding_rule" "primaries" {
  name                  = "${var.prefix}primaries-lb-${var.install_id}"
  network               = var.subnet.network
  subnetwork            = var.subnet.self_link
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.primaries.self_link
  ip_address            = google_compute_address.primaries.address
  ip_protocol           = "TCP"
  ports                 = local.ports
}

resource "google_compute_address" "internal" {
  name         = "${var.prefix}internal-lb-${var.install_id}"
  address_type = "INTERNAL"
  subnetwork   = var.subnet.self_link
}

resource "google_compute_forwarding_rule" "internal" {
  name                  = "${var.prefix}internal-lb-${var.install_id}"
  network               = var.subnet.network
  subnetwork            = var.subnet.self_link
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.internal.self_link
  ip_address            = google_compute_address.internal.address
  ip_protocol           = "TCP"
  ports                 = local.ports
}

resource "google_compute_region_backend_service" "internal" {
  name          = "${var.prefix}internal-lb-${var.install_id}"
  protocol      = "TCP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.tcp.self_link]

  backend {
    group = google_compute_region_instance_group_manager.haproxy.instance_group
  }
}

resource "google_compute_health_check" "tcp" {
  name = "${var.prefix}internal-lb-check-${var.install_id}"

  tcp_health_check {
    port = local.healthcheck_port
  }
}

resource "google_compute_firewall" "internal-ilb-fw" {
  name    = "${var.prefix}internal-lb-fw-${var.install_id}"
  network = var.subnet.network

  allow {
    protocol = "tcp"
    ports    = local.ports
  }

  source_ranges = [var.subnet.ip_cidr_range]
}

resource "google_compute_firewall" "internal-hc" {
  name    = "${var.prefix}internal-lb-hc-${var.install_id}"
  network = var.subnet.network

  allow {
    protocol = "tcp"
    ports    = [local.healthcheck_port]
  }

  source_ranges = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
}
