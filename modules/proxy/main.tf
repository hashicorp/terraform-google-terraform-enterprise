locals {
  ports  = concat(var.ports, [var.k8s_api_port])
  prefix = "${var.prefix}proxy"
}

resource "google_compute_health_check" "load_balancer_out" {
  name = "${local.prefix}-lb-out-${var.install_id}"

  description = "Check the health of the Kubernetes API."
  project     = var.project
  tcp_health_check {
    port = var.k8s_api_port
  }
}

resource "google_compute_region_backend_service" "load_balancer_out" {
  health_checks = [google_compute_health_check.load_balancer_out.self_link]
  name          = "${local.prefix}-lb-out-${var.install_id}"

  backend {
    group = var.primaries

    description = "Target the primary compute instance group."
  }
  description = "Serve traffic outgoing from the proxy."
  project     = var.project
  protocol    = "TCP"
  region      = var.region
  timeout_sec = 10
}

resource "google_compute_address" "load_balancer_out" {
  name = "${local.prefix}-lb-out-${var.install_id}"

  address_type = "INTERNAL"
  description  = "The IP address of the load balancer for the traffic outgoing from the proxy."
  project      = var.project
  region       = var.region
  subnetwork   = var.subnet.self_link
}

resource "google_compute_forwarding_rule" "load_balancer_out" {
  name = "${local.prefix}-lb-out-${var.install_id}"

  backend_service       = google_compute_region_backend_service.load_balancer_out.self_link
  description           = "Forward traffic outgoing from the proxy to the outgoing backend service."
  ip_address            = google_compute_address.load_balancer_out.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network               = var.subnet.network
  ports                 = local.ports
  project               = var.project
  region                = var.region
  subnetwork            = var.subnet.self_link
}

resource "google_compute_health_check" "load_balancer_in" {
  name = "${local.prefix}-lb-in-${var.install_id}"

  description = "Check the health of the Kubernetes API."
  project     = var.project
  tcp_health_check {
    port = var.k8s_api_port
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
  description          = "The template for the node compute instances of the proxy."
  instance_description = "A node compute instance of the proxy."
  metadata_startup_script = templatefile(
    "${path.module}/templates/setup-proxy.tmpl",
    {
      cluster_assistant_port = var.cluster_assistant_port,
      host                   = google_compute_address.load_balancer_out.address,
      k8s_api_port           = var.k8s_api_port,
    }
  )
  name_prefix = "${local.prefix}-node-${var.install_id}-"
  network_interface {
    subnetwork = var.subnet.self_link

    subnetwork_project = var.project
  }
  project = var.project
  region  = var.region

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "node" {
  base_instance_name = "${local.prefix}-node-${var.install_id}"
  name               = "${local.prefix}-node-${var.install_id}"
  region             = var.region
  version {
    name              = "${local.prefix}-node-version-${var.install_id}"
    instance_template = google_compute_instance_template.node.self_link
  }

  description = "Manages the node compute instances of the proxy."
  named_port {
    name = "https"
    port = var.k8s_api_port
  }
  project     = var.project
  target_size = 2
}

resource "google_compute_region_backend_service" "load_balancer_in" {
  health_checks = [google_compute_health_check.load_balancer_in.self_link]
  name          = "${local.prefix}-lb-in-${var.install_id}"

  backend {
    group = google_compute_region_instance_group_manager.node.instance_group

    description = "Target the node compute instance group."
  }
  description = "Serve traffic incoming to the proxy."
  project     = var.project
  protocol    = "TCP"
  region      = var.region
  timeout_sec = 10
}

resource "google_compute_address" "load_balancer_in" {
  name = "${local.prefix}-lb-in-${var.install_id}"

  address_type = "INTERNAL"
  description  = "The IP address of the load balancer for the traffic incoming to the proxy."
  project      = var.project
  region       = var.region
  subnetwork   = var.subnet.self_link
}

resource "google_compute_forwarding_rule" "load_balancer_in" {
  name = "${local.prefix}-lb-in-${var.install_id}"

  backend_service       = google_compute_region_backend_service.load_balancer_in.self_link
  description           = "Forward traffic incoming to the proxy to the incoming backend service."
  ip_address            = google_compute_address.load_balancer_in.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network               = var.subnet.network
  ports                 = local.ports
  project               = var.project
  region                = var.region
  subnetwork            = var.subnet.self_link
}
