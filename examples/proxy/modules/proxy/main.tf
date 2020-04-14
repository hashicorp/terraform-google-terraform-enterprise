locals {
  port = "3128"
}

data "template_cloudinit_config" "main" {
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/cloud-config.yaml.tmpl", { http_port = local.port })
  }

  base64_encode = true
  gzip          = true
}

resource "google_service_account" "main" {
  account_id = "${var.prefix}proxy"

  description  = "The identity to be associated with the TFE proxy."
  display_name = "TFE Proxy"
}

resource "google_compute_instance" "main" {
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20200317"
      type  = "pd-ssd"
    }
  }
  machine_type = "n1-standard-4"
  name         = "${var.prefix}proxy"
  network_interface {
    subnetwork         = var.vpc_subnetwork_self_link
    subnetwork_project = var.vpc_subnetwork_project

    access_config {
      # An empty configuration implies a public IP address.
    }
  }

  allow_stopping_for_update = true
  description               = "A proxy for TFE."
  labels                    = var.labels
  metadata = {
    user-data          = data.template_cloudinit_config.main.rendered
    user-data-encoding = "base64"
  }
  service_account {
    scopes = ["cloud-platform"]

    email = google_service_account.main.email
  }
}

resource "google_compute_firewall" "application" {
  name    = "${var.prefix}proxy-application"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"
  }
  description             = "Allow ingress of traffic from the subnetwork IP address range to the proxy."
  direction               = "INGRESS"
  enable_logging          = true
  source_service_accounts = [var.service_account_primaries_email, var.service_account_secondaries_email]
  target_service_accounts = [google_service_account.main.email]
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.prefix}proxy-ssh"
  network = var.vpc_network_self_link

  allow {
    protocol = "tcp"

    ports = ["22"]
  }
  description             = "Allow ingress of SSH traffic from any source to the proxy."
  direction               = "INGRESS"
  enable_logging          = true
  target_service_accounts = [google_service_account.main.email]
}
