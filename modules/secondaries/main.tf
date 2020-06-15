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
  }

  can_ip_forward = true
  description    = "The template for compute instances in the TFE secondaries."
  name_prefix    = "${var.prefix}secondary-"
  labels         = var.labels
  metadata       = var.metadata
  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account_email
  }

  lifecycle {
    create_before_destroy = true
  }
}

# This name is used to avoid the following issues while recreating the secondaries:
# - a new instance group manager is created before the existing one is destoryed which causes a name collision
# - the existing autoscaler target can not be changed but it does not automatically taint
resource "random_pet" "group_manager_name" {
  keepers = {
    "template" = google_compute_instance_template.main.id
  }
  length    = 1
  prefix    = "${var.prefix}secondaries"
  separator = "-"
}

resource "google_compute_region_instance_group_manager" "main" {
  base_instance_name = "${var.prefix}secondary"
  name               = random_pet.group_manager_name.id
  region             = google_compute_instance_template.main.region
  version {
    instance_template = google_compute_instance_template.main.self_link
  }

  description = "The manager for the compute instance group of the TFE secondaries."
  named_port {
    name = "application"
    port = var.vpc_application_tcp_port
  }
  named_port {
    name = "install-dashboard"
    port = var.vpc_install_dashboard_tcp_port
  }

  lifecycle {
    create_before_destroy = true
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
  name   = random_pet.group_manager_name.id
  target = google_compute_region_instance_group_manager.main.self_link
}
