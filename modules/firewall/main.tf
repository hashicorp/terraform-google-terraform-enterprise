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

resource "google_compute_firewall" "weave" {
  name    = "${var.prefix}weave-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = [6783]
  }
  allow {
    protocol = "udp"

    ports = [6783, 6784]
  }
  allow {
    protocol = "esp"
  }
  description             = "Allow ingress of Weave traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  source_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
  target_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
}

resource "google_compute_firewall" "cluster_assistant" {
  name    = "${var.prefix}cluster-assistant-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = [23010]
  }
  description             = "Allow ingress of Cluster Assistant traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  source_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
  target_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
}
