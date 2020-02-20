locals {
  primary_count = 3
}

resource "google_compute_instance" "primary" {
  # The number of primaries must be hard coded to 3 when Internal Production Mode
  # is selected. Currently, that mode does not support scaling.
  count = local.primary_count

  name         = "${var.prefix}primary-${count.index}-${var.install_id}"
  machine_type = var.primary_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image_family
      size  = var.boot_disk_size
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = var.subnet.self_link

    access_config {
      // public IP
    }
  }

  metadata = {
    user-data          = var.cluster-config.primary_cloudinit[count.index]
    user-data-encoding = "base64"
  }

  labels = {
    "name" = var.prefix
  }
  service_account {
    scopes = ["cloud-platform"]

    email = var.primary_service_account_email
  }
}

resource "google_compute_instance_group" "primary" {
  name = "${var.prefix}primary-${var.install_id}"
  zone = var.zone

  project = var.project

  description = "The group of TFE primary compute instances."
  instances   = google_compute_instance.primary.*.self_link
  named_port {
    name = "application"
    port = 443
  }
  named_port {
    name = "kubernetes"
    port = 6443
  }
  named_port {
    name = "replicated"
    port = 8800
  }
  named_port {
    name = "assist"
    port = 23010
  }

  depends_on = [google_compute_instance.primary]
}
