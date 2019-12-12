resource "google_compute_firewall" "tfe" {
  name    = "tfe-firewall"
  network = "${google_compute_network.tfe_vpc.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "6443", "8800", "23010"]
  }
}

resource "google_compute_firewall" "lb-healthchecks" {
  name          = "lb-healthcheck-firewall"
  network       = "${google_compute_network.tfe_vpc.name}"
  source_ranges = ["${var.healthchk_ips}", "${google_compute_subnetwork.tfe_subnet.ip_cidr_range}"]

  allow {
    protocol = "tcp"
  }
}
