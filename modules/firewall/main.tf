resource "google_compute_firewall" "tfe" {
  name    = "${var.prefix}firewall-${var.install_id}"
  network = var.vpc_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = concat(["22", "80", "443", "6443", "8800", "23010"], var.firewall_ports)
  }
}

resource "google_compute_firewall" "lb-healthchecks" {
  name          = "${var.prefix}lb-healthcheck-firewall-${var.install_id}"
  network       = var.vpc_name
  source_ranges = concat([var.subnet_ip_range], var.healthcheck_ips)

  allow {
    protocol = "tcp"
  }
}
