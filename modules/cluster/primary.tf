data "google_compute_zones" "available" {
  region = var.region
}

locals {
  primary_count = 3
  zone          = data.google_compute_zones.available.names[0]
}

resource "google_compute_instance" "primary" {
  # The number of primaries must be hard coded to 3 when Internal Production Mode
  # is selected. Currently, that mode does not support scaling.
  count = local.primary_count

  name         = "${var.prefix}primary-${count.index}-${var.install_id}"
  machine_type = var.primary_machine_type
  zone         = local.zone

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

resource "google_compute_instance_group" "primaries" {
  name        = "${var.prefix}primary-group-${var.install_id}"
  description = "primary-servers"

  zone      = local.zone
  instances = google_compute_instance.primary.*.self_link

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

  depends_on = [google_compute_instance.primary]
}

resource "google_compute_network_endpoint_group" "https" {
  name         = "${var.prefix}primary-cluster-${var.install_id}"
  subnetwork   = var.subnet.self_link
  network      = var.subnet.network
  default_port = "443"
  zone         = local.zone
}

resource "google_compute_network_endpoint" "https" {
  count                  = local.primary_count
  network_endpoint_group = google_compute_network_endpoint_group.https.name

  instance   = google_compute_instance.primary[count.index].name
  port       = 443
  ip_address = google_compute_instance.primary[count.index].network_interface[0].network_ip
  zone       = local.zone
}
