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
    ptfe-hostname        = "${var.prefix}primary-${count.index}-${var.install_id}.${data.google_dns_managed_zone.dnszone.dns_name}"
    airgap-installer-url = var.airgap_package_url == "none" ? "none" : count.index == 0 ? var.airgap_installer_url : local.internal_airgap_url
  })

  metadata_startup_script = file("${path.module}/files/install-ptfe.sh")

  labels = {
    "name" = var.prefix
  }
}

locals {
  dns_project = var.dns_project == "" ? var.project : var.dns_project
}

data "google_dns_managed_zone" "dnszone" {
  name    = var.dnszone
  project = local.dns_project
}

resource "google_dns_record_set" "primarydns" {
  count   = local.primary_count
  name    = "${var.prefix}primary-${count.index}-${var.install_id}.${data.google_dns_managed_zone.dnszone.dns_name}"
  type    = "A"
  ttl     = 300
  project = local.dns_project

  managed_zone = data.google_dns_managed_zone.dnszone.name

  rrdatas = [element(
    google_compute_instance.primary.*.network_interface.0.access_config.0.nat_ip,
    count.index,
  )]
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
