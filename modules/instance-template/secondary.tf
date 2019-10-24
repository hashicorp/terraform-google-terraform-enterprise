resource "google_compute_instance_template" "secondary" {
  name_prefix    = "${var.prefix}-secondary-template-"
  machine_type   = "${var.secondary_machine_type}"
  region         = "${var.region}"
  can_ip_forward = true

  disk {
    source_image = "${var.image_family}"
    auto_delete  = true
    boot         = true
    disk_size_gb = "${var.boot_disk_size}"
    disk_type    = "pd-ssd"
  }

  network_interface {
    subnetwork = "${var.ptfe_subnet}"

    access_config {
      // Public IP
    }
  }

  metadata = {
    //enable-oslogin       = "TRUE"
    bootstrap-token      = "${var.bootstrap_token_id}.${var.bootstrap_token_suffix}"
    setup-token          = "${var.setup_token}"
    custom-ca-cert-url   = "${var.ca_bundle_url}"
    cluster-api-endpoint = "${var.cluster_endpoint}:6443"
    primary-pki-url      = "http://${var.cluster_endpoint}:${local.assistant_port}/api/v1/pki-download?token=${var.setup_token}"
    health-url           = "http://${var.cluster_endpoint}:${local.assistant_port}/healthz"
    b64-license          = "${var.b64-license}"
    ptfe-role            = "secondary"
    role-id              = "0"
    ptfe-install-url     = "${var.ptfe_install_url}"
    jq-url               = "${var.jq_url}"
    #installtype          = "${var.install_type}"
    repl-data            = "${var.repl_data}"
    release-sequence     = "${var.release_sequence}"
    airgap-package-url   = "${var.airgap_package_url}"
    airgap-installer-url = "${var.airgap_installer_url}"
    encpasswd            = "${var.encryption_password}"
    pg_user              = "${var.postgresql_user}"
    pg_password          = "${var.postgresql_password}"
    pg_netloc            = "${var.postgresql_address}"
    pg_dbname            = "${var.postgresql_database}"
    pg_extra_params      = "${var.postgresql_extra_params}"
    gcs_credentials      = "${var.gcs_credentials == "" ? base64encode(file("${var.credentials_file}")) : var.gcs_credentials}"
    gcs_project          = "${var.gcs_project == "" ? var.project : var.gcs_project}"
    gcs_bucket           = "${var.gcs_bucket}"
    weave_cidr           = "${var.weave_cidr}"
    repl_cidr            = "${var.repl_cidr}"
  }
  metadata_startup_script = "${file("${path.module}/../../files/install-ptfe.sh")}"
  labels = {
    "name" = "${var.prefix}"
  }
}
