locals {
  ports  = concat(var.ports, [var.k8s_api_port])
  prefix = "${var.prefix}proxy"
}

resource "google_compute_health_check" "load_balancer_out" {
  name = "${local.prefix}-lb-out-${var.install_id}"

  tcp_health_check {
    port = var.k8s_api_port
  }
}

resource "google_compute_region_backend_service" "load_balancer_out" {
  name          = "${local.prefix}-lb-out-${var.install_id}"
  protocol      = "TCP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.load_balancer_out.self_link]

  backend {
    group = var.primaries
  }
}

resource "google_compute_address" "load_balancer_out" {
  name         = "${local.prefix}-lb-out-${var.install_id}"
  address_type = "INTERNAL"
  subnetwork   = var.subnet.self_link
}

resource "google_compute_forwarding_rule" "load_balancer_out" {
  name                  = "${local.prefix}-lb-out-${var.install_id}"
  network               = var.subnet.network
  subnetwork            = var.subnet.self_link
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.load_balancer_out.self_link
  ip_address            = google_compute_address.load_balancer_out.address
  ip_protocol           = "TCP"
  ports                 = local.ports
}

resource "google_compute_health_check" "load_balancer_in" {
  name = "${local.prefix}-lb-in-${var.install_id}"

  tcp_health_check {
    port = var.k8s_api_port
  }
}

resource "google_compute_instance_template" "node" {
  name_prefix    = "${local.prefix}-node-${var.install_id}-"
  machine_type   = "n1-standard-1"
  can_ip_forward = true

  disk {
    source_image = "ubuntu-1804-lts"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    disk_type    = "pd-ssd"
  }

  network_interface {
    subnetwork = var.subnet.self_link
  }

  metadata_startup_script = templatefile(
    "${path.module}/templates/setup-proxy.tmpl",
    {
      cluster_assistant_port = var.cluster_assistant_port,
      host                   = google_compute_address.load_balancer_out.address,
      k8s_api_port           = var.k8s_api_port,
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "node" {
  name   = "${local.prefix}-node-${var.install_id}"
  region = var.region

  base_instance_name = "${local.prefix}-node-${var.install_id}"

  version {
    instance_template = google_compute_instance_template.node.self_link
  }

  target_size = 2

  named_port {
    name = "https"
    port = var.k8s_api_port
  }
}

resource "google_compute_region_backend_service" "load_balancer_in" {
  name          = "${local.prefix}-lb-in-${var.install_id}"
  protocol      = "TCP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.load_balancer_in.self_link]

  backend {
    group = google_compute_region_instance_group_manager.node.instance_group
  }
}

resource "google_compute_address" "load_balancer_in" {
  name         = "${local.prefix}-lb-in-${var.install_id}"
  address_type = "INTERNAL"
  subnetwork   = var.subnet.self_link
}

resource "google_compute_forwarding_rule" "load_balancer_in" {
  name                  = "${local.prefix}-lb-in-${var.install_id}"
  network               = var.subnet.network
  subnetwork            = var.subnet.self_link
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.load_balancer_in.self_link
  ip_address            = google_compute_address.load_balancer_in.address
  ip_protocol           = "TCP"
  ports                 = local.ports
}
