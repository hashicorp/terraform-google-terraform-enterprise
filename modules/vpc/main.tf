resource "google_compute_network" "main" {
  name = "${var.prefix}vpc"

  auto_create_subnetworks = false
  description             = "The network for TFE."
}

resource "google_compute_subnetwork" "main" {
  ip_cidr_range = var.subnetwork_ip_cidr_range
  name          = "${var.prefix}subnet"
  network       = google_compute_network.main.self_link
}

resource "google_compute_router" "main" {
  name    = "${var.prefix}router"
  network = google_compute_network.main.self_link
}

resource "google_compute_router_nat" "main" {
  name                               = "${var.prefix}router-nat"
  router                             = google_compute_router.main.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "external_load_balancer" {
  name = "${var.prefix}elb"

  description = "The global address of the TFE external load balancer."
}

resource "google_compute_global_address" "postgresql" {
  provider = google-beta

  name = "${var.prefix}postgresql"

  address       = "10.200.1.0"
  address_type  = "INTERNAL"
  description   = "The global address of the TFE PostgreSQL database."
  network       = google_compute_network.main.self_link
  prefix_length = 24
  purpose       = "VPC_PEERING"
}

locals {
  primaries_service_account = [var.service_account_primaries_email]
  primaries_and_secondaries_service_accounts = [
    var.service_account_primaries_email,
    var.service_account_secondaries_email
  ]
  internal_load_balancer_service_account = [var.service_account_internal_load_balancer_email]
  ssh_ui_ports = [
    var.application_tcp_port,
    var.ssh_tcp_port,
    var.replicated_ui_tcp_port
  ]
}

resource "google_compute_firewall" "health_checks_application" {
  name    = "${var.prefix}health-checks-application"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [var.application_tcp_port]
  }
  description             = "Allow ingress of application traffic from the Google health check IP address ranges to the primaries and the secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_ranges           = var.health_check_ip_cidr_ranges
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}

resource "google_compute_firewall" "health_checks_kubernetes" {
  name    = "${var.prefix}health-checks-kubernetes"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [var.kubernetes_tcp_port]
  }
  description             = "Allow ingress of Kubernetes traffic from the Google health check IP address ranges to the primaries and internal load balancer."
  direction               = "INGRESS"
  enable_logging          = true
  source_ranges           = var.health_check_ip_cidr_ranges
  target_service_accounts = [var.service_account_primaries_email, var.service_account_internal_load_balancer_email]
}

resource "google_compute_firewall" "allow_all_ssh_ui" {
  name    = "${var.prefix}allow-all-ssh-ui"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = local.ssh_ui_ports
  }
  description             = "Allow ingress of SSH and UI traffic from any source to the primaries and the secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}

resource "google_compute_firewall" "replicated" {
  name    = "${var.prefix}replicated"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = var.replicated_tcp_port_ranges
  }
  description             = "Allow ingress of Replicated traffic between the primaries and the secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}

resource "google_compute_firewall" "kubernetes_internal_load_balancer" {
  name    = "${var.prefix}kubernetes-ilb"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [var.kubernetes_tcp_port]
  }
  description             = "Allow ingress of Kubernetes traffic from the primaries and the secondaries to the internal load balancer."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.internal_load_balancer_service_account
}

resource "google_compute_firewall" "kubernetes_primaries" {
  name    = "${var.prefix}kubernetes-primaries"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [var.kubernetes_tcp_port]
  }
  description    = "Allow ingress of Kubernetes traffic from all compute instances to the primaries."
  direction      = "INGRESS"
  enable_logging = true
  source_service_accounts = [
    var.service_account_primaries_email,
    var.service_account_secondaries_email,
    var.service_account_internal_load_balancer_email
  ]
  target_service_accounts = local.primaries_service_account
}

resource "google_compute_firewall" "cluster_assistant_internal_load_balancer" {
  name    = "${var.prefix}cluster-assistant-ilb"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [var.cluster_assistant_tcp_port]
  }
  description             = "Allow ingress of Cluster Assistant traffic from the primaries and the secondaries to the internal load balancer."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.internal_load_balancer_service_account
}

resource "google_compute_firewall" "cluster_assistant_primaries" {
  name    = "${var.prefix}cluster-assistant-primaries"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [var.cluster_assistant_tcp_port]
  }
  description             = "Allow ingress of Cluster Assistant traffic from the internal load balancer to the primaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.internal_load_balancer_service_account
  target_service_accounts = local.primaries_service_account
}

resource "google_compute_firewall" "etcd" {
  name    = "${var.prefix}etcd"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = var.etcd_tcp_port_ranges
  }
  description             = "Allow ingress of etcd traffic between the primaries."
  enable_logging          = true
  source_service_accounts = local.primaries_service_account
  target_service_accounts = local.primaries_service_account
}

resource "google_compute_firewall" "kubelet" {
  name    = "${var.prefix}kubelet"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [var.kubelet_tcp_port]
  }
  description             = "Allow ingress of Kubelet traffic between the primaries and the secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}

resource "google_compute_firewall" "weave" {
  name    = "${var.prefix}weave"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [var.weave_tcp_port]
  }
  allow {
    protocol = "udp"

    ports = var.weave_udp_port_ranges
  }
  allow {
    protocol = "esp"
  }
  description             = "Allow ingress of Weave traffic between the primaries and the secondaries."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = local.primaries_and_secondaries_service_accounts
  target_service_accounts = local.primaries_and_secondaries_service_accounts
}
