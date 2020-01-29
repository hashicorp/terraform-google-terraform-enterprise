resource "google_compute_health_check" "autohealing" {
  name                = "${var.prefix}haproxy-health-check-${var.install_id}"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 ds

  tcp_health_check {
    port = "6443"
  }
}

resource "google_compute_instance_template" "haproxy" {
  name_prefix    = "${var.prefix}haproxy-template-"
  machine_type   = "n1-standard-1"
  can_ip_forward = true

  disk {
    source_image = "ubuntu-1804-lts"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    disk_type    = "pd-ssd"
  }

  network_interface {
    subnetwork = var.subnet.self_link
  }

  metadata_startup_script = templatefile("${path.module}/files/setup-proxy.sh", {
    host = google_compute_address.primaries.address
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "haproxy" {
  name   = "${var.prefix}haproxy-${var.install_id}"
  region = var.region

  base_instance_name = "${var.prefix}haproxy-${var.install_id}"

  version {
    instance_template = google_compute_instance_template.haproxy.self_link
  }

  target_size = 2

  named_port {
    name = "https"
    port = 6443
  }
}
