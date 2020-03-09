locals {
  primary_service_accounts           = [var.service_account_primary_cluster_email]
  primary_and_proxy_service_accounts = [var.service_account_primary_cluster_email, var.service_account_proxy_email]
  primary_and_secondary_service_accounts = [
    var.service_account_primary_cluster_email,
    var.service_account_secondary_cluster_email
  ]
  proxy_service_accounts = [var.service_account_proxy_email]
  ssh_ui_ports = [
    var.port_application_tcp,
    var.port_ssh_tcp,
    var.port_replicated_ui_tcp
  ]
}

resource "google_compute_firewall" "health_checks_application" {
  name    = "${var.prefix}health-checks-application"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_application_tcp]
  }
  description             = "Allow ingress of application traffic from the Google health check IP address ranges to the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_ranges           = var.health_check_ip_cidr_ranges
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "health_checks_kubernetes" {
  name    = "${var.prefix}health-checks-kubernetes"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_kubernetes_tcp]
  }
  description             = "Allow ingress of Kubernetes traffic from the Google health check IP address ranges to the primary and proxy compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_ranges           = var.health_check_ip_cidr_ranges
  target_service_accounts = [var.service_account_primary_cluster_email, var.service_account_proxy_email]
}

resource "google_compute_firewall" "allow_all_ssh_ui" {
  name    = "${var.prefix}allow-all-ssh-ui"
  network = var.vpc_network_self_link

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
  name    = "${var.prefix}deny-internal-ssh-ui"
  network = var.vpc_network_self_link

  deny {
    protocol = "tcp"

    ports = local.ssh_ui_ports
  }
  description    = "Deny ingress of SSH and UI traffic between addresses in the internal network."
  direction      = "INGRESS"
  enable_logging = true
  source_ranges  = [var.vpc_subnetwork_ip_cidr_range]
}

resource "google_compute_firewall" "replicated" {
  name    = "${var.prefix}replicated"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = var.port_replicated_tcp_ranges
  }
  description             = "Allow ingress of Replicated traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "kubernetes_proxy" {
  name    = "${var.prefix}kubernetes-proxy"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_kubernetes_tcp]
  }
  description             = "Allow ingress of Kubernetes traffic from the primary and secondary compute instances to the proxy compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.proxy_service_accounts
}

resource "google_compute_firewall" "kubernetes_primaries" {
  name    = "${var.prefix}kubernetes-primaries"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_kubernetes_tcp]
  }
  description             = "Allow ingress of Kubernetes traffic from the proxy compute instances and the primary compute instances to the primary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_proxy_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "cluster_assistant_proxy" {
  name    = "${var.prefix}cluster-assistant-proxy"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_cluster_assistant_tcp]
  }
  description             = "Allow ingress of Cluster Assistant traffic from the primary and secondary compute instances to the proxy compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.proxy_service_accounts
}

resource "google_compute_firewall" "cluster_assistant_primaries" {
  name    = "${var.prefix}cluster-assistant-primaries"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_cluster_assistant_tcp]
  }
  description             = "Allow ingress of Cluster Assistant traffic from the proxy compute instances to the primary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.proxy_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "etcd" {
  name    = "${var.prefix}etcd"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = var.port_etcd_tcp_ranges
  }
  description             = "Allow ingress of etcd traffic between the primary compute instances."
  enable_logging          = true
  source_service_accounts = local.primary_service_accounts
  target_service_accounts = local.primary_service_accounts
}

resource "google_compute_firewall" "kubelet" {
  name    = "${var.prefix}kubelet"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_kubelet_tcp]
  }
  description             = "Allow ingress of Kubelet traffic between the primary and secondary compute instances."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primary_and_secondary_service_accounts
  target_service_accounts = local.primary_and_secondary_service_accounts
}

resource "google_compute_firewall" "weave" {
  name    = "${var.prefix}weave"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_weave_tcp]
  }
  allow {
    protocol = "udp"

    ports = var.port_weave_udp_ranges
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
