resource "google_compute_url_map" "ptfe" {
  name        = "ptfe-urlmap"
  description = "ptfe"

  default_service = "${google_compute_backend_service.primary.self_link}"

  host_rule {
    hosts        = ["${var.frontenddns}.${var.domain}"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.primary.self_link}"

    path_rule {
      paths   = ["/dashboard"]
      service = "${google_compute_backend_service.dashboard.self_link}"
    }

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.primary.self_link}"
    }
  }
}

resource "google_compute_backend_service" "dashboard" {
  name        = "dashboard"
  port_name   = "dashboard"
  protocol    = "HTTPS"
  timeout_sec = 10

  health_checks = ["${google_compute_health_check.primary.self_link}"]

  backend {
    description = "primary servers"
    group       = "${var.instance_group}"
  }
}

resource "google_compute_backend_service" "primary" {
  name        = "primary-backend"
  port_name   = "https"
  protocol    = "HTTPS"
  timeout_sec = 10

  health_checks = ["${google_compute_health_check.primary.self_link}"]

  backend {
    description = "primary servers"
    group       = "${var.instance_group}"
  }
}

resource "google_compute_health_check" "primary" {
  name               = "primary-healthcheck"
  check_interval_sec = 5
  timeout_sec        = 4

  https_health_check {
    request_path = "/healthz"
    port         = "6443"
  }
}

/*

add named port block to instance group definition (repl 8800)
then specify that named port in the backend service definition

*/

