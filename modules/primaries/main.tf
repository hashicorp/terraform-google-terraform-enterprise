locals {
  # The instance group must be hard-coded to 3. See the Limitations section of the submodule README for more details.
  instance_count = 3
}

# All available zones are used to deploy the primaries in a regional manner.
data "google_compute_zones" "up" {
  status = "UP"
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
  }
  zone = element(data.google_compute_zones.up.names, count.index)

  allow_stopping_for_update = true
  description               = "The compute instance which acts as TFE Primary ${count.index}."
  labels                    = var.labels
  metadata = {
    user-data          = var.cloud_init_configs[count.index]
    user-data-encoding = "base64"
  }
  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account_email
  }
}

resource "google_compute_instance_group" "main" {
  count = local.instance_count

  name        = "${var.prefix}primary-${count.index}"
  description = "The group comprising the compute instance which acts as TFE Primary ${count.index}."
  zone        = google_compute_instance.main[count.index].zone

  instances = [google_compute_instance.main[count.index].self_link]
  named_port {
    name = "application"
    port = var.vpc_application_tcp_port
  }
  named_port {
    name = "install-dashboard"
    port = var.vpc_install_dashboard_tcp_port
  }
  named_port {
    name = "kubernetes"
    port = var.vpc_kubernetes_tcp_port
  }
}
