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

  /*lifecycle {
    create_before_destroy = true
  }*/

  metadata = {
    //enable-oslogin       = "TRUE"
    bootstrap-token      = "${var.bootstrap_token_id}.${var.bootstrap_token_suffix}"
    setup-token          = "${var.setup_token}"
    custom-ca-cert-url   = "${var.ca_cert_url}"
    cluster-api-endpoint = "${var.cluster_endpoint}:6443"
    primary-pki-url      = "http://${var.cluster_endpoint}:${local.assistant_port}/api/v1/pki-download?token=${var.setup_token}"
    health-url           = "http://${var.cluster_endpoint}:${local.assistant_port}/healthz"
    ptfe-role            = "secondary"
    role-id              = "0"
    installtype          = "${var.install_type}"
    repl-data            = "${var.repl_data}"
    release-sequence     = "${var.release_sequence}"
  }
  metadata_startup_script = "${file("${path.module}/../../files/install-ptfe.sh")}"
  labels = {
    "name" = "${var.prefix}"
  }
}
