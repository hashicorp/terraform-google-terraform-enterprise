locals {
  name_in  = "${local.prefix}in"
  name_out = "${local.prefix}out"
  ports    = [var.port_cluster_assistant_tcp, var.port_kubernetes_tcp]
  prefix   = "${var.prefix}ilb-"
}

resource "google_compute_health_check" "internal_load_balancer_out" {
  name = local.name_out

  description = "Check the health of the Kubernetes API."
  tcp_health_check {
    port = var.port_kubernetes_tcp
  }
}

resource "google_compute_region_backend_service" "internal_load_balancer_out" {
  health_checks = [google_compute_health_check.internal_load_balancer_out.self_link]
  name          = local.name_out

  backend {
    group = var.primary_cluster_instance_group_self_link

    description = "Target the primary cluster instance group."
  }
  description = "Serve to the primary cluster traffic outgoing from the internal load balancer."
  protocol    = "TCP"
  timeout_sec = 10
}

resource "google_compute_address" "internal_load_balancer_out" {
  name = local.name_out

  address_type = "INTERNAL"
  description  = "The IP address of the internal load balancer for the outgoing traffic."
  subnetwork   = var.vpc_subnetwork_self_link
}

resource "google_compute_forwarding_rule" "internal_load_balancer_out" {
  name = local.name_out

  backend_service       = google_compute_region_backend_service.internal_load_balancer_out.self_link
  description           = "Forward to primary cluster traffic outgoing from the internal load balancer."
  ip_address            = google_compute_address.internal_load_balancer_out.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network               = var.vpc_network_self_link
  ports                 = local.ports
  subnetwork            = var.vpc_subnetwork_self_link
}

resource "google_compute_health_check" "internal_load_balancer_in" {
  name = local.name_in

  description = "Check the health of the Kubernetes API."
  tcp_health_check {
    port = var.port_kubernetes_tcp
  }
}

resource "google_compute_instance_template" "node" {
  disk {
    source_image = "ubuntu-1804-lts"

    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    disk_type    = "pd-ssd"
  }
  machine_type = "n1-standard-1"

  can_ip_forward       = true
  description          = "The template for the node compute instances of the internal load balancer."
  instance_description = "A node compute instance of the internal load balancer."
  labels               = var.labels
  metadata_startup_script = templatefile(
    "${path.module}/templates/setup-proxy.tmpl",
    {
      port_cluster_assistant_tcp = var.port_cluster_assistant_tcp,
      host                       = google_compute_address.internal_load_balancer_out.address,
      port_kubernetes_tcp        = var.port_kubernetes_tcp
    }
  )
  name_prefix = "${local.prefix}node-"
  network_interface {
    subnetwork         = var.vpc_subnetwork_self_link
    subnetwork_project = var.vpc_subnetwork_project
  }
  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account_email
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "node" {
  base_instance_name = "${local.prefix}node"
  name               = "${local.prefix}node"
  region             = google_compute_instance_template.node.region
  version {
    name              = "${local.prefix}node-version"
    instance_template = google_compute_instance_template.node.self_link
  }

  description = "Manages the node compute instances of the internal load balancer."
  named_port {
    name = "kubernetes"
    port = var.port_kubernetes_tcp
  }
  named_port {
    name = "cluster-assistant"
    port = var.port_cluster_assistant_tcp
  }
  target_size = 2
}

resource "google_compute_region_backend_service" "internal_load_balancer_in" {
  health_checks = [google_compute_health_check.internal_load_balancer_in.self_link]
  name          = local.name_in

  backend {
    group = google_compute_region_instance_group_manager.node.instance_group

    description = "Target the node compute instance group."
  }
  description = "Serve to the node instance group traffic incoming to the internal load balancer."
  protocol    = "TCP"
  timeout_sec = 10
}

resource "google_compute_address" "internal_load_balancer_in" {
  name = local.name_in

  address_type = "INTERNAL"
  description  = "The IP address of the internal load balancer for the incoming traffic."
  subnetwork   = var.vpc_subnetwork_self_link
}

resource "google_compute_forwarding_rule" "internal_load_balancer_in" {
  name = local.name_in

  backend_service       = google_compute_region_backend_service.internal_load_balancer_in.self_link
  description           = "Forward to the nodes traffic incoming to the internal load balancer."
  ip_address            = google_compute_address.internal_load_balancer_in.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network               = var.vpc_network_self_link
  ports                 = local.ports
  subnetwork            = var.vpc_subnetwork_self_link
}
