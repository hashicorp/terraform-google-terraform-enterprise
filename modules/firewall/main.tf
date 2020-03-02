resource "google_compute_firewall" "external_ssh_ui" {
  name    = "${var.prefix}external-ssh-ui"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [22, 443, 8800]
  }
  description             = "Allow ingress of SSH and UI traffic from the external network to the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = [var.service_account_primary_cluster_email, var.service_account_secondary_cluster_email]
}

resource "google_compute_firewall" "internal_ssh_ui" {
  name    = "${var.prefix}internal-ssh-ui"
  network = var.vpc_network_self_link

  deny {
    protocol = "tcp"

    ports = [22, 443, 8800]
  }
  description             = "Deny egress of SSH and UI traffic from the internal network."
  direction               = "EGRESS"
  enable_logging          = true
  source_service_accounts = [var.service_account_primary_cluster_email, var.service_account_secondary_cluster_email]
}

resource "google_compute_firewall" "application" {
  name    = "${var.prefix}application"
  network = var.vpc_network_self_link

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = concat(["6443", "23010"], var.ports)
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
