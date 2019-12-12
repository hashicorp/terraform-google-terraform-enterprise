locals {
  ports            = ["80", "443", "6443", "23010"]
  healthcheck_port = "23010"
}

data "google_compute_subnetwork" "internal" {
  name = var.subnet
}

resource "google_compute_address" "internal" {
  name         = "${var.prefix}internal-lb-${var.install_id}"
  address_type = "INTERNAL"
  subnetwork   = data.google_compute_subnetwork.internal.self_link
}

resource "google_compute_forwarding_rule" "internal" {
  name                  = "${var.prefix}internal-lb-${var.install_id}"
  network               = data.google_compute_subnetwork.internal.network
  subnetwork            = data.google_compute_subnetwork.internal.self_link
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
  health_checks = [google_compute_health_check.http.self_link]

  backend {
    group = google_compute_region_instance_group_manager.haproxy.instance_group
  }
}

resource "google_compute_health_check" "http" {
  name = "${var.prefix}internal-lb-check-${var.install_id}"

  http_health_check {
    port = local.healthcheck_port
  }
}

resource "google_compute_firewall" "internal-ilb-fw" {
  name    = "${var.prefix}internal-lb-fw-${var.install_id}"
  network = data.google_compute_subnetwork.internal.network

  allow {
    protocol = "tcp"
    ports    = local.ports
  }

  source_ranges = [data.google_compute_subnetwork.internal.ip_cidr_range]
}

resource "google_compute_firewall" "internal-hc" {
  name    = "${var.prefix}internal-lb-hc-${var.install_id}"
  network = data.google_compute_subnetwork.internal.network

  allow {
    protocol = "tcp"
    ports    = [local.healthcheck_port]
  }

  source_ranges = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
}
