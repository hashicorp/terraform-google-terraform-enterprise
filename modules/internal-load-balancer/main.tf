locals {
  name = "${var.prefix}ilb"
}

resource "google_compute_address" "main" {
  name = local.name

  address_type = "INTERNAL"
  description  = "The internal IP address of the TFE internal load balancer."
  subnetwork   = var.vpc_subnetwork_self_link
}

resource "google_compute_instance" "main" {
  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = var.disk_size
      type  = "pd-ssd"
    }
  }
  machine_type = var.machine_type
  name         = local.name
  network_interface {
    subnetwork         = var.vpc_subnetwork_self_link
    subnetwork_project = var.vpc_subnetwork_project

    network_ip = google_compute_address.main.address
  }

  allow_stopping_for_update = true
  description               = "TFE internal load balancer."
  labels                    = var.labels
  metadata_startup_script = templatefile(
    "${path.module}/templates/startup.sh.tmpl",
    {
      address                        = google_compute_address.main.address
      primary_0_address              = var.primaries_addresses[0]
      primary_1_address              = var.primaries_addresses[1]
      primary_2_address              = var.primaries_addresses[2]
      ssl_bundle_url                 = var.ssl_bundle_url
      vpc_application_tcp_port       = var.vpc_application_tcp_port
      vpc_install_dashboard_tcp_port = var.vpc_install_dashboard_tcp_port
    }
  )
  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account_email
  }
}

resource "google_compute_instance_group" "main" {
  name        = local.name
  description = "A group of compute instances which comprises the TFE internal load balancer."

  instances = [google_compute_instance.main.self_link]
  named_port {
    name = "application"
    port = var.vpc_application_tcp_port
  }
}
