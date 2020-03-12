locals {
  instance_count = 3
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
  name         = "${var.prefix}primary-${count.index}"
  network_interface {
    subnetwork         = var.vpc_subnetwork_self_link
    subnetwork_project = var.vpc_subnetwork_project

    access_config {
      # An empty configuration implies a public IP address.
    }
  }

  description = "A compute instance in the TFE primary cluster."
  labels      = var.labels
  metadata = {
    user-data          = var.cloud_init_configs[count.index]
    user-data-encoding = "base64"
  }
}

resource "google_compute_instance_group" "main" {
  name        = "${var.prefix}primary"
  description = "primary-servers"

  instances = google_compute_instance.main.*.self_link

  named_port {
    name = "https"
    port = 443
  }

  named_port {
    name = "cluster"
    port = 6443
  }

  named_port {
    name = "assist"
    port = 23010
  }

  depends_on = [google_compute_instance.main]
}

resource "google_compute_network_endpoint_group" "main" {
  name    = "${var.prefix}primary"
  network = var.vpc_network_self_link

  default_port = "443"
  description  = "The endpoint group for the TFE primary cluster."
  subnetwork   = var.vpc_subnetwork_self_link
}

resource "google_compute_network_endpoint" "main" {
  count = local.instance_count

  instance               = google_compute_instance.main[count.index].name
  ip_address             = google_compute_instance.main[count.index].network_interface[0].network_ip
  network_endpoint_group = google_compute_network_endpoint_group.main.name
  port                   = 443
}
