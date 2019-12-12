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
    subnetwork = var.subnet

    access_config {
      // public IP
    }
  }

  metadata = merge(local.common_metadata, {
    ptfe-role            = count.index == 0 ? "main" : "primary"
    role-id              = count.index
    ptfe-hostname        = var.access_fqdn
    airgap-installer-url = var.airgap_package_url == "none" ? "none" : count.index == 0 ? var.airgap_installer_url : local.internal_airgap_url
  })

  metadata_startup_script = file("${path.module}/files/install-ptfe.sh")

  labels = {
    "name" = var.prefix
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

  depends_on = [google_compute_instance.primary]
}
