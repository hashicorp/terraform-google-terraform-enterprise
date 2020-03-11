locals {
  health_check_ranges      = ["35.191.0.0/16", "130.211.0.0/22"]
  primary_service_accounts = [var.primary_service_account_email]
  all_service_accounts = [
    var.primary_service_account_email,
    var.secondary_service_account_email,
    var.proxy_service_account_email
  ]
  primary_and_secondary_service_accounts = [var.primary_service_account_email, var.secondary_service_account_email]
  proxy_service_accounts                 = [var.proxy_service_account_email]
  ssh_ui_ports = concat(
    var.ports.application.tcp,
    var.ports.ssh.tcp,
    var.ports.replicated_ui.tcp
  )
}

resource "google_compute_firewall" "health_checks_application" {
  name    = "${var.prefix}-health-checks-application"
  network = var.network_name

  allow {
    protocol = "tcp"

    ports = var.ports.application.tcp
  }
  description             = "Allow ingress of application traffic from the Google health check IP address ranges to the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_ranges           = local.health_check_ranges
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "health_checks_kubernetes" {
  name    = "${var.prefix}-health-checks-kubernetes"
  network = var.network_name

  allow {
    protocol = "tcp"

    ports = var.ports.kubernetes.tcp
  }
  description             = "Allow ingress of Kubernetes traffic from the Google health check IP address ranges to the primary and proxy compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_ranges           = local.health_check_ranges
  target_service_accounts = [var.primary_service_account_email, var.proxy_service_account_email]
}

resource "google_compute_firewall" "allow_all_ssh_ui" {
  name    = "${var.prefix}-allow-all-ssh-ui"
  network = var.network_name

  allow {
    protocol = "tcp"

    ports = local.ssh_ui_ports
  }
  description             = "Allow ingress of SSH and UI traffic from any source to the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "deny_internal_ssh_ui" {
  name    = "${var.prefix}-deny-internal-ssh-ui"
  network = var.network_name

  deny {
    protocol = "tcp"

    ports = local.ssh_ui_ports
  }
  description    = "Deny ingress of SSH and UI traffic between addresses in the internal network."
  direction      = "INGRESS"
  enable_logging = true
  source_ranges  = [var.subnetwork_ip_cidr_range]
}

resource "google_compute_firewall" "replicated" {
  name    = "${var.prefix}-replicated"
  network = var.network_name

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
  name    = "${var.prefix}-kubernetes-proxy"
  network = var.network_name

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
  name    = "${var.prefix}-kubernetes-primaries"
  network = var.network_name

  allow {
    protocol = "tcp"

    ports = var.ports.kubernetes.tcp
  }
  description             = "Allow ingress of Kubernetes traffic from the proxy compute instances and the primary compute instances to the primary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.all_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "cluster_assistant_proxy" {
  name    = "${var.prefix}-cluster-assistant-proxy"
  network = var.network_name

  allow {
    protocol = "tcp"

    ports = var.ports.cluster_assistant.tcp
  }
  description             = "Allow ingress of Cluster Assistant traffic from the primary and secondary compute instances to the proxy compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.proxy_service_accounts
}

resource "google_compute_firewall" "cluster_assistant_primaries" {
  name    = "${var.prefix}-cluster-assistant-primaries"
  network = var.network_name

  allow {
    protocol = "tcp"

    ports = var.ports.cluster_assistant.tcp
  }
  description             = "Allow ingress of Cluster Assistant traffic from the proxy compute instances to the primary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.proxy_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "etcd" {
  name    = "${var.prefix}-etcd"
  network = var.network_name

  allow {
    protocol = "tcp"

    ports = var.ports.etcd.tcp
  }
  description             = "Allow ingress of etcd traffic between the primary compute instances."
  enable_logging          = true
  source_service_accounts = local.primary_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "kubelet" {
  name    = "${var.prefix}-kubelet"
  network = var.network_name

  allow {
    protocol = "tcp"

    ports = var.ports.kubelet.tcp
  }
  description             = "Allow ingress of Kubelet traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "weave" {
  name    = "${var.prefix}-weave"
  network = var.network_name

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
