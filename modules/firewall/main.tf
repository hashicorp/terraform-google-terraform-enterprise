resource "google_compute_firewall" "external_to_primaries" {
  name    = "${var.prefix}external-to-primaries-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = [
      22,
      443,
      8800,
    ]
  }
  description             = "Allow ingress of traffic from the external network to the primary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = [var.primary_service_account_email]
}

resource "google_compute_firewall" "external_to_secondaries" {
  name    = "${var.prefix}external-to-secondaries-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = [
      22,
      443,
      8800,
    ]
  }
  description             = "Allow ingress of traffic from the external network to the secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = [var.secondary_service_account_email]
}

resource "google_compute_firewall" "tfe" {
  name    = "${var.prefix}firewall-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"

    ports = concat(["6443", "23010"], var.firewall_ports)
  }
}

resource "google_compute_firewall" "weave_fast_datapath" {
  name    = "${var.prefix}weave-fast-datapath-firewall-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "esp"
  }
  description   = "Weave fast datapath traffic."
  direction     = "INGRESS"
  source_ranges = [var.subnet_ip_range]
}

resource "google_compute_firewall" "lb_healthchecks" {
  name    = "${var.prefix}lb-healthcheck-firewall-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"
  }
  source_ranges = concat([var.subnet_ip_range], var.healthcheck_ips)
}
