resource "google_compute_firewall" "application" {
  name    = "${var.prefix}application"
  network = var.vpc_network_self_link

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = concat(["22", "80", "443", "6443", "8800", "23010"], var.ports)
  }
  description = "Allow the ingress of traffic within the network."
}

resource "google_compute_firewall" "weave_fast_datapath" {
  name    = "${var.prefix}weave-fast-datapath"
  network = var.vpc_network_self_link

  allow {
    protocol = "esp"
  }
  description   = "Weave fast datapath traffic."
  direction     = "INGRESS"
  source_ranges = [var.vpc_subnetwork_ip_cidr_range]
}

resource "google_compute_firewall" "health_checks" {
  name    = "${var.prefix}health-checks"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"
  }
  description   = "Allow the ingress of traffic from health check address ranges."
  source_ranges = concat([var.vpc_subnetwork_ip_cidr_range], var.health_check_ip_cidr_ranges)
}
