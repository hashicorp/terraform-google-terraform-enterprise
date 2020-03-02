resource "google_compute_firewall" "external_ssh_ui" {
  name    = "${var.prefix}external-ssh-ui-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = [22, 443, 8800]
  }
  description             = "Allow ingress of SSH and UI traffic from the external network to the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
}

resource "google_compute_firewall" "internal_ssh_ui" {
  name    = "${var.prefix}internal-ssh-ui-${var.install_id}"
  network = var.vpc_name

  project = var.project

  deny {
    protocol = "tcp"

    ports = [22, 443, 8800]
  }
  description             = "Deny egress of SSH and UI traffic from the internal network."
  direction               = "EGRESS"
  enable_logging          = true
  source_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
}

resource "google_compute_firewall" "replicated" {
  name    = "${var.prefix}replicated-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = ["9870-9881"]
  }
  description             = "Allow ingress of Replicated traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
  target_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
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
