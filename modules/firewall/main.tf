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

resource "google_compute_firewall" "replicated" {
  name    = "${var.prefix}replicated"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = ["9870-9881"]
  }
  description             = "Allow ingress of Replicated traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = [var.service_account_primary_cluster_email, var.service_account_secondary_cluster_email]
  target_service_accounts = [var.service_account_primary_cluster_email, var.service_account_secondary_cluster_email]
}

resource "google_compute_firewall" "weave" {
  name    = "${var.prefix}weave"
  network = var.vpc_network_self_link

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
  source_service_accounts = [var.service_account_primary_cluster_email, var.service_account_secondary_cluster_email]
  target_service_accounts = [var.service_account_primary_cluster_email, var.service_account_secondary_cluster_email]
}

resource "google_compute_firewall" "cluster_assistant" {
  name    = "${var.prefix}cluster-assistant"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [23010]
  }
  description             = "Allow ingress of Cluster Assistant traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  source_service_accounts = [var.service_account_primary_cluster_email, var.service_account_secondary_cluster_email]
  target_service_accounts = [var.service_account_primary_cluster_email, var.service_account_secondary_cluster_email]
}
