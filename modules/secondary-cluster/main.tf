resource "google_compute_instance_template" "main" {
  disk {
    source_image = var.disk_image

    auto_delete  = true
    boot         = true
    disk_size_gb = var.disk_size
    disk_type    = "pd-ssd"
  }
  machine_type = var.machine_type
  network_interface {
    subnetwork         = var.vpc_subnetwork_self_link
    subnetwork_project = var.vpc_subnetwork_project

    access_config {
      # An empty configuration implies a public IP address.
    }
  }

  can_ip_forward = true
  description    = "The template for compute instances in the TFE secondary cluster."
  name_prefix    = "${var.prefix}secondary-"
  labels         = var.labels
  metadata = {
    user-data          = var.cloud_init_config
    user-data-encoding = "base64"
  }
  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account_email
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "main" {
  base_instance_name = "${var.prefix}secondary"
  name               = "${var.prefix}secondary"
  region             = google_compute_instance_template.main.region
  version {
    instance_template = google_compute_instance_template.main.self_link
  }

  description = "The manager for the compute instance group of the TFE secondary cluster."
  named_port {
    name = "application"
    port = var.port_application_tcp
  }
  named_port {
    name = "kubernetes"
    port = var.port_kubernetes_tcp
  }
  named_port {
    name = "replicated-ui"
    port = var.port_replicated_ui_tcp
  }
}

resource "google_compute_region_autoscaler" "main" {
  autoscaling_policy {
    max_replicas = var.max_instances
    min_replicas = var.min_instances

    cooldown_period = 300
    cpu_utilization {
      target = var.cpu_utilization_target
    }
  }
  name   = "${var.prefix}secondary"
  target = google_compute_region_instance_group_manager.main.self_link
}
