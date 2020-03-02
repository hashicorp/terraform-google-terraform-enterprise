locals {
  primary_service_accounts = [var.service_account_primary_cluster_email]
  primary_and_secondary_service_accounts = [
    var.service_account_primary_cluster_email,
    var.service_account_secondary_cluster_email
  ]
  proxy_service_accounts = [var.service_account_proxy_email]
}

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
  target_service_accounts = local.primary_and_secondary_service_accounts
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
  source_service_accounts = local.primary_and_secondary_service_accounts
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
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "etcd" {
  name    = "${var.prefix}etcd"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [2739, 2380, 4001, 7001]
  }
  description             = "Allow ingress of etcd traffic between the primary and secondary compute instances."
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.primary_and_secondary_service_accounts
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
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "cluster_assistant_proxy" {
  name    = "${var.prefix}cluster-assistant-proxy"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [23010]
  }
  description             = "Allow ingress of Cluster Assistant traffic from the primary and secondary compute instances to the proxy compute instances."
  direction               = "INGRESS"
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.proxy_service_accounts
}

resource "google_compute_firewall" "cluster_assistant_primaries" {
  name    = "${var.prefix}cluster-assistant-primaries"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [23010]
  }
  description             = "Allow ingress of Cluster Assistant traffic from the proxy compute instances to the primary compute instances."
  direction               = "INGRESS"
  source_service_accounts = local.proxy_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "k8s_proxy" {
  name    = "${var.prefix}k8s-proxy-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = ["6443", "10250-10252"]
  }
  description             = "Allow ingress of Kubernetes traffic from the primary and secondary compute instances to the proxy compute instances."
  direction               = "INGRESS"
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.proxy_service_accounts
}

resource "google_compute_firewall" "k8s_primaries" {
  name    = "${var.prefix}k8s-primaries-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = ["6443", "10250-10252"]
  }
  description             = "Allow ingress of Kubernetes traffic from the proxy compute instances to the primary compute instances."
  direction               = "INGRESS"
  source_service_accounts = local.proxy_service_accounts
  target_service_accounts = local.primary_service_accounts
}
