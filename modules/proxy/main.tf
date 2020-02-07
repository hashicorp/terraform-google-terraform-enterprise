locals {
  ports = concat(var.ports, [var.k8s_api_port])
}

resource "google_compute_health_check" "cluster-api" {
  name = "${var.prefix}cluster-api-check-${var.install_id}"

  tcp_health_check {
    port = var.k8s_api_port
  }
}

resource "google_compute_region_backend_service" "load_balancer_out" {
  name          = "${var.prefix}lb-out-${var.install_id}"
  protocol      = "TCP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.cluster-api.self_link]

  backend {
    group = var.primaries
  }
}

resource "google_compute_address" "load_balancer_out" {
  name         = "${var.prefix}lb-out-${var.install_id}"
  address_type = "INTERNAL"
  subnetwork   = var.subnet.self_link
}

resource "google_compute_forwarding_rule" "load_balancer_out" {
  name                  = "${var.prefix}lb-out-${var.install_id}"
  network               = var.subnet.network
  subnetwork            = var.subnet.self_link
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.load_balancer_out.self_link
  ip_address            = google_compute_address.load_balancer_out.address
  ip_protocol           = "TCP"
  ports                 = local.ports
}

resource "google_compute_health_check" "autohealing" {
  name                = "${var.prefix}node-health-check-${var.install_id}"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 ds

  tcp_health_check {
    port = var.k8s_api_port
  }
}

resource "google_compute_health_check" "tcp" {
  name = "${var.prefix}lb-in-check-${var.install_id}"

  tcp_health_check {
    port = var.k8s_api_port
  }
}

resource "google_compute_instance_template" "node" {
  name_prefix    = "${var.prefix}node-template-"
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
  name   = "${var.prefix}node-${var.install_id}"
  region = var.region

  base_instance_name = "${var.prefix}node-${var.install_id}"

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
  name          = "${var.prefix}lb-in-${var.install_id}"
  protocol      = "TCP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.tcp.self_link]

  backend {
    group = google_compute_region_instance_group_manager.node.instance_group
  }
}

resource "google_compute_address" "load_balancer_in" {
  name         = "${var.prefix}lb-in-${var.install_id}"
  address_type = "INTERNAL"
  subnetwork   = var.subnet.self_link
}

resource "google_compute_forwarding_rule" "load_balancer_in" {
  name                  = "${var.prefix}lb-in-${var.install_id}"
  network               = var.subnet.network
  subnetwork            = var.subnet.self_link
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.load_balancer_in.self_link
  ip_address            = google_compute_address.load_balancer_in.address
  ip_protocol           = "TCP"
  ports                 = local.ports
}

resource "google_compute_firewall" "load_balancer_in" {
  name    = "${var.prefix}lb-in-fw-${var.install_id}"
  network = var.subnet.network

  allow {
    protocol = "tcp"
    ports    = local.ports
  }

  source_ranges = [var.subnet.ip_cidr_range]
}

resource "google_compute_firewall" "load_balancer_in_healthcheck" {
  name    = "${var.prefix}lb-in-hc-${var.install_id}"
  network = var.subnet.network

  allow {
    protocol = "tcp"
    ports    = [var.k8s_api_port]
  }

  source_ranges = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
}
