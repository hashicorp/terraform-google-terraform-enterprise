resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10                         # 50 seconds

  http_health_check {
    request_path = "/_health_check"
    port         = "443"
  }
}

resource "google_compute_region_instance_group_manager" "secondary" {
  name = "secondary"

  base_instance_name = "ptfe-worker"
  instance_template  = "${module.instance-template.secondary_template}"
  update_strategy    = "NONE"
  region             = "${var.region}"

  target_size = "${var.worker_count}"

  named_port {
    name = "https"
    port = 443
  }

  /*lifecycle {
    create_before_destroy = true
  }*/
}
