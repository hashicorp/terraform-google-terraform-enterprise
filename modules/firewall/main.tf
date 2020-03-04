locals {
  primary_service_accounts               = [var.primary_service_account_email]
  primary_and_secondary_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
  proxy_service_accounts                 = [var.proxy_service_account_email]
  ssh_ui_ports = concat(
    var.ports.application.tcp,
    var.ports.ssh.tcp,
    var.ports.replicated_ui.tcp
  )
}

resource "google_compute_firewall" "external_ssh_ui" {
  name    = "${var.prefix}external-ssh-ui-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = local.ssh_ui_ports
  }
  description             = "Allow ingress of SSH and UI traffic from the external network to the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "internal_ssh_ui" {
  name    = "${var.prefix}internal-ssh-ui-${var.install_id}"
  network = var.vpc_name

  project = var.project

  deny {
    protocol = "tcp"

    ports = local.ssh_ui_ports
  }
  description             = "Deny egress of SSH and UI traffic from the internal network."
  direction               = "EGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "replicated" {
  name    = "${var.prefix}replicated-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = var.ports.replicated.tcp
  }
  description             = "Allow ingress of Replicated traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "kubernetes_proxy" {
  name    = "${var.prefix}kubernetes-proxy-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = var.ports.kubernetes.tcp
  }
  description             = "Allow ingress of Kubernetes traffic from the primary and secondary compute instances to the proxy compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.proxy_service_accounts
}

resource "google_compute_firewall" "kubernetes_primaries" {
  name    = "${var.prefix}kubernetes-primaries-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = var.ports.kubernetes.tcp
  }
  description             = "Allow ingress of Kubernetes traffic from the proxy compute instances to the primary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.proxy_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "cluster_assistant_proxy" {
  name    = "${var.prefix}cluster-assistant-proxy-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = var.ports.cluster_assistant.tcp
  }
  description             = "Allow ingress of Cluster Assistant traffic from the primary and secondary compute instances to the proxy compute instances."
  direction               = "INGRESS"
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.proxy_service_accounts
}

resource "google_compute_firewall" "cluster_assistant_primaries" {
  name    = "${var.prefix}cluster-assistant-primaries-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = var.ports.cluster_assistant.tcp
  }
  description             = "Allow ingress of Cluster Assistant traffic from the proxy compute instances to the primary compute instances."
  direction               = "INGRESS"
  source_service_accounts = local.proxy_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "etcd" {
  name    = "${var.prefix}etcd-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = var.ports.etcd.tcp
  }
  description             = "Allow ingress of etcd traffic between the primary compute instances."
  enable_logging          = true
  source_service_accounts = local.primary_service_accounts
  target_service_accounts = local.primary_service_accounts
}
  direction               = "INGRESS"
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.proxy_service_accounts
}

resource "google_compute_firewall" "weave" {
  name    = "${var.prefix}weave-${var.install_id}"
  network = var.vpc_name

  project = var.project

  allow {
    protocol = "tcp"

    ports = var.ports.weave.tcp
  }
  allow {
    protocol = "udp"

    ports = var.ports.weave.udp
  }
  allow {
    protocol = "esp"
  }
  description             = "Allow ingress of Weave traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.primary_and_secondary_service_accounts
}
