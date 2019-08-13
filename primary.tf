resource "google_compute_instance" "primary" {
  count        = "${var.primary_count}"
  name         = "${var.primaryhostname}-${count.index}"
  machine_type = "${var.primary_machine_type}"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "${var.image_family}"
      size  = "40"
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
    cluster-api-endpoint = "${var.primaryhostname}-0:6443"
    primary-pki-url      = "http://${var.primaryhostname}-0:${local.assistant_port}/api/v1/pki-download?token=${random_string.setup_token.result}"
    health-url           = "http://${var.primaryhostname}-0:${local.assistant_port}/healthz"
    ptfe-role            = "${count.index == 0 ? "main" : "primary"}"
    role-id              = "${count.index}"
    b64-license          = "${base64encode(file("${var.license_file}"))}"
    airgap-package-url   = "${var.airgapurl}"
    airgap-installer-url = "${var.airgap_installer_url}"
    repl-data            = "${base64encode("${random_pet.console_password.id}")}"
    ptfe-hostname        = "${var.primaryhostname}-${count.index}.${data.google_dns_managed_zone.dnszone.dns_name}"
    encpasswd            = "${var.encpasswd}"
    release-sequence     = "${var.release_sequence}"
    installtype          = "${var.install_type}"
    pg_user              = "${var.pg_user}"
    pg_password          = "${var.pg_password}"
    pg_netloc            = "${var.pg_netloc}"
    pg_dbname            = "${var.pg_dbname}"
    pg_extra_params      = "${var.pg_extra_params}"
    gcs_credentials      = "${var.gcs_credentials == "" ? base64encode(file("${var.creds}")) : var.gcs_credentials}"
    gcs_project          = "${var.gcs_project}"
    gcs_bucket           = "${var.gcs_bucket}"
  }

  metadata_startup_script = "${file("${path.module}/files/install-ptfe.sh")}"
}

data "google_dns_managed_zone" "dnszone" {
  name     = "${var.dnszone}"
}

resource "google_dns_record_set" "primarydns" {
  count = "${var.primary_count}"
  name  = "${var.primaryhostname}-${count.index}.${data.google_dns_managed_zone.dnszone.dns_name}"
  type  = "A"
  ttl   = 300

  managed_zone = "${data.google_dns_managed_zone.dnszone.name}"

  rrdatas = ["${element(google_compute_instance.primary.*.network_interface.0.access_config.0.nat_ip, count.index)}"]
}

resource "google_compute_instance_group" "primaries" {
  name        = "primary-group"
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

  lifecycle {
    create_before_destroy = true
  }
}
