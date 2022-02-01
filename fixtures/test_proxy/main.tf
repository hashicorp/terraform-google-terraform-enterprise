resource "google_service_account" "proxy" {
  account_id = var.name

  description  = "The service account of the proxy for TFE."
  display_name = "TFE Proxy"
}

resource "google_project_iam_member" "log_writer" {
  member = "serviceAccount:${google_service_account.proxy.email}"
  role   = "roles/logging.logWriter"
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
  target_service_accounts = [google_service_account.proxy.email]

  allow {
    protocol = "tcp"

    ports = [module.test_proxy_init.squid.http_port]
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
  target_service_accounts = [google_service_account.proxy.email]

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

    email = google_service_account.proxy.email
  }

  labels = var.labels
}
