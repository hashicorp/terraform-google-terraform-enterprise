resource "google_service_account" "proxy" {
  count        = var.existing_service_account_id == null ? 1 : 0
  account_id   = var.name
  description  = "The service account of the proxy for TFE."
  display_name = "TFE Proxy"
}

data "google_service_account" "proxy" {
  count      = var.existing_service_account_id == null ? 0 : 1
  account_id = var.existing_service_account_id
}

resource "google_project_iam_member" "log_writer" {
  count  = var.existing_service_account_id == null ? 1 : 0
  member = local.service_account_member
  role   = "roles/logging.logWriter"
}

resource "google_secret_manager_secret_iam_member" "http_proxy_certificate" {
  count = local.mitmproxy_selected ? 1 : 0

  member    = local.service_account_member
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.mitmproxy_ca_certificate_secret
}

resource "google_secret_manager_secret_iam_member" "http_proxy_private_key" {
  count = local.mitmproxy_selected ? 1 : 0

  member    = local.service_account_member
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.mitmproxy_ca_private_key_secret
}

module "test_proxy_init" {
  source = "github.com/hashicorp/terraform-random-tfe-utility//fixtures/test_proxy_init?ref=main"

  mitmproxy_ca_certificate_secret = var.mitmproxy_ca_certificate_secret
  mitmproxy_ca_private_key_secret = var.mitmproxy_ca_private_key_secret
}

resource "google_compute_firewall" "internal" {
  name    = "${var.name}-internal"
  network = var.network.self_link

  description             = "The firewall which allows internal access to the proxy."
  direction               = "INGRESS"
  source_ranges           = [var.subnetwork.ip_cidr_range]
  target_service_accounts = [local.service_account.email]

  allow {
    protocol = "tcp"

    ports = [local.http_port]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.name}-ssh"
  network = var.network.self_link

  description             = "The firewall which allows the ingress of Identity-Aware Proxy SSH traffic to the proxy."
  direction               = "INGRESS"
  source_ranges           = ["35.235.240.0/20"]
  target_service_accounts = [local.service_account.email]

  allow {
    protocol = "tcp"

    ports = ["22"]
  }
}

resource "google_compute_instance" "proxy" {
  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  machine_type = "n1-standard-2"
  name         = var.name

  description = "A proxy for TFE."
  metadata_startup_script = local.mitmproxy_selected ? (
    module.test_proxy_init.mitmproxy.user_data_script
  ) : module.test_proxy_init.squid.user_data_script

  network_interface {
    subnetwork = var.subnetwork.self_link
  }

  service_account {
    scopes = ["cloud-platform"]

    email = local.service_account.email
  }

  labels = var.labels
}
