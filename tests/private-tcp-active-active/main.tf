resource "random_pet" "main" {
  length    = 1
  prefix    = "ptaa"
  separator = "-"
}

resource "google_service_account" "http_proxy" {
  account_id = local.name

  description  = "The service account of the HTTP proxy for TFE."
  display_name = "TFE HTTP Proxy"
}

resource "google_project_iam_member" "log_writer" {
  member = local.http_proxy_account
  role   = "roles/logging.logWriter"
}

resource "google_secret_manager_secret_iam_member" "http_proxy_certificate" {
  member    = local.http_proxy_account
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.ca_certificate_secret_id
}

resource "google_secret_manager_secret_iam_member" "http_proxy_private_key" {
  member    = local.http_proxy_account
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.ca_private_key_secret_id
}

resource "google_compute_firewall" "http_proxy" {
  name    = local.name
  network = module.tfe.network.self_link

  description             = "The firewall which allows internal access to the HTTP proxy."
  direction               = "INGRESS"
  source_ranges           = [module.tfe.subnetwork.ip_cidr_range]
  target_service_accounts = [google_service_account.http_proxy.email]

  allow {
    protocol = "tcp"

    ports = [local.http_proxy_port]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "${local.name}-ssh"
  network = module.tfe.network.self_link

  description             = "The firewall which allows the ingress of Identity-Aware Proxy SSH traffic to the HTTP proxy."
  direction               = "INGRESS"
  source_ranges           = ["35.235.240.0/20"]
  target_service_accounts = [google_service_account.http_proxy.email]

  allow {
    protocol = "tcp"

    ports = ["22"]
  }
}

data "google_compute_image" "rhel" {
  name    = "rhel-7-v20200403"
  project = "gce-uefi-images"
}

data "google_compute_image" "ubuntu" {
  name = "ubuntu-2004-focal-v20210119a"

  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "http_proxy" {
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.id
    }
  }

  machine_type = "n1-standard-2"
  name         = local.name

  description = "An HTTP proxy for TFE."
  metadata_startup_script = templatefile(
    "${path.module}/templates/startup.sh.tpl",
    {
      certificate_secret_id = var.ca_certificate_secret_id
      http_proxy_port       = local.http_proxy_port
      private_key_secret_id = var.ca_private_key_secret_id
    }
  )

  network_interface {
    subnetwork = module.tfe.subnetwork.self_link
  }

  service_account {
    scopes = ["cloud-platform"]

    email = google_service_account.http_proxy.email
  }

  labels = local.labels

}

module "tfe" {
  source = "../.."

  dns_zone_name  = var.cloud_dns_name
  fqdn           = "private-tcp-active-active.${var.cloud_dns_domain}"
  namespace      = random_pet.main.id
  node_count     = 2
  license_secret = var.license_secret_id
  labels         = local.labels

  ca_certificate_secret  = var.ca_certificate_secret_id
  iact_subnet_list       = ["${google_compute_instance.http_proxy.network_interface[0].network_ip}/32"]
  iact_subnet_time_limit = 1440
  load_balancer          = "PRIVATE_TCP"
  proxy_ip               = "${google_compute_instance.http_proxy.network_interface[0].network_ip}:${local.http_proxy_port}"
  redis_auth_enabled     = true
  ssl_certificate_secret = var.ssl_certificate_secret_id
  ssl_private_key_secret = var.ssl_private_key_secret_id
  vm_disk_source_image   = data.google_compute_image.rhel.self_link
  vm_machine_type        = "n1-standard-32"
}
