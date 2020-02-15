resource "google_compute_instance_template" "secondary" {
  name_prefix    = "${var.prefix}secondary-template-"
  machine_type   = var.secondary_machine_type
  region         = var.region
  can_ip_forward = true

  disk {
    source_image = var.image_family
    auto_delete  = true
    boot         = true
    disk_size_gb = var.boot_disk_size
    disk_type    = "pd-ssd"
  }

  network_interface {
    subnetwork = var.subnet.self_link

    access_config {
      // Public IP
    }
  }

  metadata = {
    user-data          = var.cluster-config.secondary_cloudinit
    user-data-encoding = "base64"
  }

  labels = {
    "name" = var.prefix
  }

  service_account {
    scopes = ["cloud-platform"]

    email = var.secondary_service_account_email
  }
}

resource "google_compute_region_instance_group_manager" "secondary" {
  base_instance_name = "${var.prefix}secondary-${var.install_id}"
  name               = "${var.prefix}secondary-${var.install_id}"
  region             = var.region
  version {
    instance_template = google_compute_instance_template.secondary.self_link
  }

  project = var.project

  description = "The group of TFE secondary compute instances."

  named_port {
    name = "https"
    port = 443
  }
}

resource "google_compute_region_autoscaler" "secondary" {
  name   = "${var.prefix}secondary-autoscaler-${var.install_id}"
  target = google_compute_region_instance_group_manager.secondary.self_link

  autoscaling_policy {
    max_replicas    = var.max_secondaries
    min_replicas    = var.min_secondaries
    cooldown_period = 300

    cpu_utilization {
      target = var.autoscaler_cpu_threshold
    }
  }
}
