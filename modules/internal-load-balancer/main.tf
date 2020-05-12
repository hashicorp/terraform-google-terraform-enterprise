locals {
  name_in  = "${local.prefix}in"
  name_out = "${local.prefix}out"
  ports    = [var.vpc_cluster_assistant_tcp_port, var.vpc_kubernetes_tcp_port]
  prefix   = "${var.prefix}ilb-"
}

resource "google_compute_health_check" "internal_load_balancer_out" {
  name = local.name_out

  check_interval_sec = 10
  description        = "Check the health of the Kubernetes API."
  tcp_health_check {
    port = var.vpc_kubernetes_tcp_port
  }
  unhealthy_threshold = 3
}

resource "google_compute_region_backend_service" "internal_load_balancer_out" {
  health_checks = [google_compute_health_check.internal_load_balancer_out.self_link]
  name          = local.name_out

  dynamic "backend" {
    for_each = var.primaries_instance_groups_self_links
    content {
      group = backend.value

      description = "A group of compute instances which comprises some of the TFE primaries."
    }
  }
  description = "Serve to the TFE primaries egress traffic from the internal load balancer."
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
  description           = "Forward to the TFE primaries egress traffic from the internal load balancer."
  ip_address            = google_compute_address.internal_load_balancer_out.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network               = var.vpc_network_self_link
  ports                 = local.ports
  subnetwork            = var.vpc_subnetwork_self_link
}

resource "google_compute_health_check" "internal_load_balancer_in" {
  name = local.name_in

  check_interval_sec = 10
  description        = "Check the health of the Kubernetes API."
  tcp_health_check {
    port = var.vpc_kubernetes_tcp_port
  }
  unhealthy_threshold = 3
}

resource "google_compute_instance_template" "router" {
  disk {
    source_image = "ubuntu-1804-lts"

    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    disk_type    = "pd-ssd"
  }
  machine_type = "n1-standard-1"

  can_ip_forward       = true
  description          = "The template for the router compute instances of the internal load balancer."
  instance_description = "A router compute instance of the internal load balancer."
  labels               = var.labels
  metadata_startup_script = templatefile(
    "${path.module}/templates/setup-proxy.tmpl",
    {
      vpc_cluster_assistant_tcp_port = var.vpc_cluster_assistant_tcp_port,
      host                           = google_compute_address.internal_load_balancer_out.address,
      vpc_kubernetes_tcp_port        = var.vpc_kubernetes_tcp_port
    }
  )
  name_prefix = "${local.prefix}router-"
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

resource "google_compute_region_instance_group_manager" "router" {
  base_instance_name = "${local.prefix}router"
  name               = "${local.prefix}router"
  region             = google_compute_instance_template.router.region
  version {
    name              = "${local.prefix}router-version"
    instance_template = google_compute_instance_template.router.self_link
  }

  description = "Manages the router compute instances of the internal load balancer."
  named_port {
    name = "kubernetes"
    port = var.vpc_kubernetes_tcp_port
  }
  named_port {
    name = "cluster-assistant"
    port = var.vpc_cluster_assistant_tcp_port
  }
  target_size = 2

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_backend_service" "internal_load_balancer_in" {
  health_checks = [google_compute_health_check.internal_load_balancer_in.self_link]
  name          = local.name_in

  backend {
    group = google_compute_region_instance_group_manager.router.instance_group

    description = "Target the router compute instance group."
  }
  description = "Serve to the router instance group traffic incoming to the internal load balancer."
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
  description           = "Forward to the routers traffic incoming to the internal load balancer."
  ip_address            = google_compute_address.internal_load_balancer_in.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network               = var.vpc_network_self_link
  ports                 = local.ports
  subnetwork            = var.vpc_subnetwork_self_link
}
