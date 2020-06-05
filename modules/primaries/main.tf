locals {
  load_balancer_name   = "${local.prefix}lb"
  load_balancer_prefix = "${local.load_balancer_name}-"
  # The instance group must be hard-coded to 3. See the Limitations section of the submodule README for more details.
  instance_count               = 3
  load_balancer_instance_count = 2
  name                         = "${var.prefix}primary"
  prefix                       = "${local.name}-"
  ports                        = [var.vpc_cluster_assistant_tcp_port, var.vpc_kubernetes_tcp_port]
}

# All available zones are used to deploy the primaries in a regional manner.
data "google_compute_zones" "up" {
  status = "UP"
}

resource "google_compute_instance" "main" {
  count = local.instance_count

  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = var.disk_size
      type  = "pd-ssd"
    }
  }
  machine_type = var.machine_type
  name         = "${local.prefix}${count.index}"
  network_interface {
    subnetwork         = var.vpc_subnetwork_self_link
    subnetwork_project = var.vpc_subnetwork_project
  }
  zone = element(data.google_compute_zones.up.names, count.index)

  allow_stopping_for_update = true
  description               = "TFE primary ${count.index}."
  labels                    = var.labels
  metadata = {
    user-data          = var.cloud_init_configs[count.index]
    user-data-encoding = "base64"
  }
  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account_email
  }
}

resource "google_compute_instance_group" "main" {
  count = local.instance_count

  name        = "${local.prefix}${count.index}"
  description = "Contains only TFE primary ${count.index} for regional load balancing purposes."
  zone        = google_compute_instance.main[count.index].zone

  instances = [google_compute_instance.main[count.index].self_link]
  named_port {
    name = "application"
    port = var.vpc_application_tcp_port
  }
  named_port {
    name = "install-dashboard"
    port = var.vpc_install_dashboard_tcp_port
  }
}

resource "google_compute_health_check" "kubernetes_api" {
  provider = google-beta

  name = "${local.prefix}k8s"

  check_interval_sec = 10
  description        = "The Kubernetes API on the TFE primaries."
  # Beta
  log_config {
    enable = true
  }
  tcp_health_check {
    port = var.vpc_kubernetes_tcp_port
  }
  unhealthy_threshold = local.instance_count
}

resource "google_compute_region_backend_service" "main" {
  health_checks = [google_compute_health_check.kubernetes_api.self_link]
  name          = local.name

  dynamic "backend" {
    for_each = google_compute_instance_group.main[*].self_link
    content {
      group = backend.value

      description = "One of the TFE primaries."
    }
  }
  description = "The TFE primaries."
  protocol    = "TCP"
  timeout_sec = 10
}

resource "google_compute_address" "main" {
  name = local.name

  address_type = "INTERNAL"
  description  = "The private IP address for the TFE primaries."
  subnetwork   = var.vpc_subnetwork_self_link
}

resource "google_compute_forwarding_rule" "main" {
  name = local.name

  backend_service       = google_compute_region_backend_service.main.self_link
  description           = "Forward to the TFE primaries traffic received by the private IP address."
  ip_address            = google_compute_address.main.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network               = var.vpc_network_self_link
  ports                 = local.ports
  subnetwork            = var.vpc_subnetwork_self_link
}

resource "google_compute_instance_template" "load_balancer" {
  disk {
    source_image = var.load_balancer_disk_image

    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    disk_type    = "pd-ssd"
  }
  machine_type = "n1-standard-1"

  can_ip_forward       = true
  description          = "A router for the TFE primaries load balancer."
  instance_description = "A router for the TFE primaries load balancer."
  labels               = var.labels
  metadata_startup_script = templatefile(
    "${path.module}/templates/setup-proxy.tmpl",
    {
      vpc_cluster_assistant_tcp_port = var.vpc_cluster_assistant_tcp_port,
      host                           = google_compute_address.main.address,
      vpc_kubernetes_tcp_port        = var.vpc_kubernetes_tcp_port
    }
  )
  name_prefix = "${local.load_balancer_name}-"
  network_interface {
    subnetwork         = var.vpc_subnetwork_self_link
    subnetwork_project = var.vpc_subnetwork_project
  }
  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account_load_balancer_email
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "load_balancer" {
  base_instance_name = local.load_balancer_name
  name               = local.load_balancer_name
  region             = google_compute_instance_template.load_balancer.region
  version {
    name              = google_compute_instance_template.load_balancer.name
    instance_template = google_compute_instance_template.load_balancer.self_link
  }

  description = "Manages the routers of the TFE primaries load balancer."
  target_size = local.load_balancer_instance_count

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "load_balancer_kubernetes_api" {
  provider = google-beta

  name = "${local.load_balancer_prefix}k8s"

  check_interval_sec = 10
  description        = "The Kubernetes API on the routers of the TFE primaries load balancer."
  # Beta
  log_config {
    enable = true
  }
  tcp_health_check {
    port = var.vpc_kubernetes_tcp_port
  }
  unhealthy_threshold = local.load_balancer_instance_count
}

resource "google_compute_region_backend_service" "load_balancer" {
  health_checks = [google_compute_health_check.load_balancer_kubernetes_api.self_link]
  name          = local.load_balancer_name

  backend {
    group = google_compute_region_instance_group_manager.load_balancer.instance_group

    description = "Target the routers of the TFE primaries load balancer."
  }
  description = "The routers of the TFE primaries load balancer."
  protocol    = "TCP"
  timeout_sec = 10
}

resource "google_compute_address" "load_balancer" {
  name = local.load_balancer_name

  address_type = "INTERNAL"
  description  = "The internal IP address of the routers of the TFE primaries load balancer."
  subnetwork   = var.vpc_subnetwork_self_link
}

resource "google_compute_forwarding_rule" "load_balancer" {
  name = local.load_balancer_name

  backend_service       = google_compute_region_backend_service.load_balancer.self_link
  description           = "Forward to the routers of the TFE primaries load balancer traffic received by the private IP address."
  ip_address            = google_compute_address.load_balancer.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  network               = var.vpc_network_self_link
  ports                 = local.ports
  subnetwork            = var.vpc_subnetwork_self_link
}
