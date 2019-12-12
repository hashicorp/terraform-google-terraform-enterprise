resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/_health_check"
    port         = "443"
  }
}

resource "google_compute_instance_template" "secondary" {
  name_prefix    = "${var.prefix}-secondary-template-"
  machine_type   = var.secondary_machine_type
  region         = var.region
  can_ip_forward = true

  disk {
    source_image = var.image_family
    auto_delete  = true
    boot         = true
    disk_size_gb = var.boot_disk_size
    disk_type    = "pd-ssd"
  }

  network_interface {
    subnetwork = var.subnet

    access_config {
      // Public IP
    }
  }

  metadata = merge(local.common_metadata, {
    ptfe-role            = "secondary"
    role-id              = "0"
    airgap-installer-url = var.airgap_package_url == "none" ? "none" : local.internal_airgap_url
  })

  metadata_startup_script = file("${path.module}/files/install-ptfe.sh")

  labels = {
    "name" = var.prefix
  }
}

resource "google_compute_region_instance_group_manager" "secondary" {
  name = "secondary"

  base_instance_name = "${var.prefix}-secondary"
  region             = var.region

  version {
    instance_template = google_compute_instance_template.secondary.self_link
  }

  target_size = var.secondary_count

  named_port {
    name = "https"
    port = 443
  }
}

