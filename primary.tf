resource "google_compute_instance" "primary" {
  # The number of primaries must be hard coded to 3 when Internal Production Mode
  # is selected. Currently, that mode does not support scaling. In other modes, the
  count = "${var.install_type == "ipm" ? 3 : var.primary_count}"

  name         = "${var.prefix}-primary-${count.index}"
  machine_type = "${var.primary_machine_type}"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "${var.image_family}"
      size  = "${var.boot_disk_size}"
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"

    access_config {
      // public IP
    }
  }

  metadata = {
    //enable-oslogin       = "TRUE"
    bootstrap-token      = "${random_string.bootstrap_token_id.result}.${random_string.bootstrap_token_suffix.result}"
    setup-token          = "${random_string.setup_token.result}"
    cluster-api-endpoint = "${var.prefix}-primary-0:6443"
    primary-pki-url      = "http://${var.prefix}-primary-0:${local.assistant_port}/api/v1/pki-download?token=${random_string.setup_token.result}"
    health-url           = "http://${var.prefix}-primary-0:${local.assistant_port}/healthz"
    custom-ca-cert-url   = "${var.ca_bundle_url}"
    ptfe-role            = "${count.index == 0 ? "main" : "primary"}"
    role-id              = "${count.index}"
    b64-license          = "${base64encode(file("${var.license_file}"))}"
    airgap-package-url   = "${var.airgap_package_url}"
    airgap-installer-url = "${var.airgap_installer_url}"
    repl-data            = "${base64encode("${random_pet.console_password.id}")}"
    ptfe-hostname        = "${var.prefix}-primary-${count.index}.${data.google_dns_managed_zone.dnszone.dns_name}"
    encpasswd            = "${var.encryption_password}"
    release-sequence     = "${var.release_sequence}"
    installtype          = "${var.install_type}"
    pg_user              = "${var.postgresql_user}"
    pg_password          = "${var.postgresql_password}"
    pg_netloc            = "${var.postgresql_address}"
    pg_dbname            = "${var.postgresql_database}"
    pg_extra_params      = "${var.postgresql_extra_params}"
    gcs_credentials      = "${var.gcs_credentials == "" ? base64encode(file("${var.credentials_file}")) : var.gcs_credentials}"
    gcs_project          = "${var.gcs_project}"
    gcs_bucket           = "${var.gcs_bucket}"
  }

  metadata_startup_script = "${file("${path.module}/files/install-ptfe.sh")}"

  labels = {
    "name" = "${var.prefix}"
  }
}

data "google_dns_managed_zone" "dnszone" {
  name    = "${var.dns_zone}"
  project = "${var.dns_project == "" ? var.project : var.dns_project}"
}

resource "google_dns_record_set" "primarydns" {
  count   = "${var.primary_count}"
  name    = "${var.prefix}-primary-${count.index}.${data.google_dns_managed_zone.dnszone.dns_name}"
  type    = "A"
  ttl     = 300
  project = "${var.dns_project == "" ? var.project : var.dns_project}"

  managed_zone = "${data.google_dns_managed_zone.dnszone.name}"

  rrdatas = ["${element(google_compute_instance.primary.*.network_interface.0.access_config.0.nat_ip, count.index)}"]
}

resource "google_compute_instance_group" "primaries" {
  name        = "${var.prefix}-primary-group"
  description = "primary-servers"
  zone        = "${var.zone}"

  instances = ["${google_compute_instance.primary.*.self_link}"]

  named_port {
    name = "https"
    port = 443
  }

  named_port {
    name = "dashboard"
    port = 8800
  }
}
