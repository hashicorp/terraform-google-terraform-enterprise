locals {
  all_service_accounts = [
    var.service_account_primaries_email,
    var.service_account_secondaries_email,
    var.service_account_internal_load_balancer_email
  ]
  primaries_service_account = [var.service_account_primaries_email]
  primaries_and_internal_load_balancer_service_accounts = [
    var.service_account_primaries_email,
    var.service_account_internal_load_balancer_email
  ]
  primaries_and_secondaries_service_accounts = [
    var.service_account_primaries_email,
    var.service_account_secondaries_email
  ]
  internal_load_balancer_service_account = [var.service_account_internal_load_balancer_email]
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
  description             = "Allow ingress of application traffic from the Google health check IP address ranges to the primaries and secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_ranges           = var.health_check_ip_cidr_ranges
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}

resource "google_compute_firewall" "health_checks_kubernetes" {
  name    = "${var.prefix}health-checks-kubernetes"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_kubernetes_tcp]
  }
  description             = "Allow ingress of Kubernetes traffic from the Google health check IP address ranges to the primaries and internal load balancer."
  direction               = "INGRESS"
  enable_logging          = true
  source_ranges           = var.health_check_ip_cidr_ranges
  target_service_accounts = [var.service_account_primaries_email, var.service_account_internal_load_balancer_email]
}

resource "google_compute_firewall" "allow_all_ssh_ui" {
  name    = "${var.prefix}allow-all-ssh-ui"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = local.ssh_ui_ports
  }
  description             = "Allow ingress of SSH and UI traffic from any source to the primaries and secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}

resource "google_compute_firewall" "replicated" {
  name    = "${var.prefix}replicated"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = var.port_replicated_tcp_ranges
  }
  description             = "Allow ingress of Replicated traffic between the primaries and secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}

resource "google_compute_firewall" "kubernetes_internal_load_balancer" {
  name    = "${var.prefix}kubernetes-ilb"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_kubernetes_tcp]
  }
  description             = "Allow ingress of Kubernetes traffic from the primaries and secondaries to the internal load balancer."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.internal_load_balancer_service_account
}

resource "google_compute_firewall" "kubernetes_primaries" {
  name    = "${var.prefix}kubernetes-primaries"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_kubernetes_tcp]
  }
  description             = "Allow ingress of Kubernetes traffic from all compute instances to the primaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.all_service_accounts
  target_service_accounts = local.primaries_service_account
}

resource "google_compute_firewall" "cluster_assistant_internal_load_balancer" {
  name    = "${var.prefix}cluster-assistant-ilb"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_cluster_assistant_tcp]
  }
  description             = "Allow ingress of Cluster Assistant traffic from the primaries and secondaries to the internal load balancer."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.internal_load_balancer_service_account
}

resource "google_compute_firewall" "cluster_assistant_primaries" {
  name    = "${var.prefix}cluster-assistant-primaries"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_cluster_assistant_tcp]
  }
  description             = "Allow ingress of Cluster Assistant traffic from the internal load balancer to the primaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.internal_load_balancer_service_account
  target_service_accounts = local.primaries_service_account
}

resource "google_compute_firewall" "etcd" {
  name    = "${var.prefix}etcd"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = var.port_etcd_tcp_ranges
  }
  description             = "Allow ingress of etcd traffic between the primaries."
  enable_logging          = true
  source_service_accounts = local.primaries_service_account
  target_service_accounts = local.primaries_service_account
}

resource "google_compute_firewall" "kubelet" {
  name    = "${var.prefix}kubelet"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = [var.port_kubelet_tcp]
  }
  description             = "Allow ingress of Kubelet traffic between the primaries and secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.primaries_and_secondaries_service_accounts
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
  description             = "Allow ingress of Weave traffic between the primaries and secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}
