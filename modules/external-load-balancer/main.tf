resource "google_compute_health_check" "application" {
  name = "${var.prefix}application"

  check_interval_sec = 5
  description        = "The TFE application health check."
  https_health_check {
    port         = var.vpc_application_tcp_port
    request_path = "/_health_check"
  }
  timeout_sec = 4
}

resource "google_compute_backend_service" "application" {
  health_checks = [google_compute_health_check.application.self_link]
  name          = "${var.prefix}application"

  backend {
    group = var.primaries_instance_group_self_link

    balancing_mode        = "RATE"
    description           = "The TFE primaries."
    max_rate_per_instance = 333
  }
  backend {
    group = var.secondaries_instance_group_manager_instance_group

    balancing_mode        = "RATE"
    description           = "The TFE secondaries."
    max_rate_per_instance = 333
  }
  port_name   = "application"
  protocol    = "HTTPS"
  timeout_sec = 10
}

resource "google_compute_health_check" "replicated_ui" {
  name = "${var.prefix}replicated-ui"

  check_interval_sec = 5
  description        = "The TFE Replicated UI health check."
  tcp_health_check {
    port = var.vpc_replicated_ui_tcp_port
  }
  timeout_sec = 4
}

resource "google_compute_backend_service" "replicated_ui" {
  health_checks = [google_compute_health_check.replicated_ui.self_link]
  name          = "${var.prefix}replicated-ui"

  backend {
    group = var.primaries_instance_group_self_link

    balancing_mode        = "RATE"
    description           = "The TFE primaries."
    max_rate_per_instance = 333
  }
  backend {
    group = var.secondaries_instance_group_manager_instance_group

    balancing_mode        = "RATE"
    description           = "The TFE secondaries."
    max_rate_per_instance = 333
  }
  port_name   = "replicated-ui"
  protocol    = "HTTPS"
  timeout_sec = 10
}

resource "google_compute_url_map" "main" {
  default_service = google_compute_backend_service.application.self_link
  name            = "${var.prefix}all-requests"

  description = "The URL map for all TFE requests."
  host_rule {
    hosts        = [var.dns_fqdn]
    path_matcher = "allpaths"

    description = "Match the fully-qualified domain name of TFE."
  }
  path_matcher {
    default_service = google_compute_backend_service.application.self_link
    name            = "allpaths"

    description = "Redirect requests to the application or the install dashboard path."
    # This rule covers paths which are unique to the install dashboard.
    path_rule {
      # FIXME: https://tfe.emp-gcp.ptfedev.com/api/v1/support returns 502
      paths = [
        "/api/v1",
        "/api/v1/*",
        "/auditlog",
        "/auditlog/*",
        "/authenticate",
        "/authenticate/*",
        "/ceph",
        "/ceph/*",
        "/cluster",
        "/cluster/*",
        "/console",
        "/console/*",
        "/dashboard",
        "/dashboard/*",
        "/license",
        "/license/*",
        "/premkit",
        "/premkit/*",
        "/releases",
        "/releases/*",
        "/settings",
        "/settings/*",
        "/support",
        "/support/*",
      ]

      service = google_compute_backend_service.replicated_ui.self_link
    }
    # This rule covers install dashboard asset paths under /assets. /assets is also used by application so paths must
    # be listed explicitly.
    path_rule {
      paths = [
        "/assets/03f50a3a6f195be73370626cc2887118.woff",
        "/assets/36c91049d46f93c801176f06abb4b7f0.woff2",
        "/assets/448c34a56d699c29117adc64c43affeb.woff2",
        "/assets/50145685042b4df07a1fd19957275b81.ttf",
        "/assets/629a55a7e793da068dc580d184cc0e31.ttf",
        "/assets/8e976923f9d9c249cf32e75191cf797a.woff",
        "/assets/a410ef2b4a38aa95291d109020a0b723.woff",
        "/assets/af7ae505a9eed503f8b8e6982036873e.woff2",
        "/assets/auditlog.main.23a3afa649a44fbe9fdb.js",
        "/assets/authenticate.main.23a3afa649a44fbe9fdb.js",
        "/assets/b06871f281fee6b241d60582ae9369b9.ttf",
        "/assets/brand.23a3afa649a44fbe9fdb.css",
        "/assets/c2d24dfda8a924bb6109080139a75698.woff2",
        "/assets/c7dcce084c445260a266f92db56f5517.ttf",
        "/assets/cluster.main.23a3afa649a44fbe9fdb.js",
        "/assets/commons.23a3afa649a44fbe9fdb.css",
        "/assets/commons.23a3afa649a44fbe9fdb.js",
        "/assets/consolesettings.23a3afa649a44fbe9fdb.css",
        "/assets/consolesettings.main.23a3afa649a44fbe9fdb.js",
        "/assets/dashboard.23a3afa649a44fbe9fdb.css",
        "/assets/dashboard.main.23a3afa649a44fbe9fdb.js",
        "/assets/e18bbf611f2a2e43afc071aa2f4e1512.ttf",
        "/assets/ec4dad2ea1198fed8332457c7778e7f1.woff2",
        "/assets/fa2772327f55d8198301fdb8bcfc8158.woff",
        "/assets/fee66e712a8a08eef5805a46892932ad.woff",
        "/assets/licenseview.main.23a3afa649a44fbe9fdb.js",
        "/assets/releases.main.23a3afa649a44fbe9fdb.js",
        "/assets/settings.23a3afa649a44fbe9fdb.css",
        "/assets/settings.main.23a3afa649a44fbe9fdb.js",
        "/assets/snapshots.main.23a3afa649a44fbe9fdb.js",
        "/assets/support.main.23a3afa649a44fbe9fdb.js",
      ]

      service = google_compute_backend_service.replicated_ui.self_link
    }
  }
  test {
    host    = var.dns_fqdn
    path    = "/session"
    service = google_compute_backend_service.application.self_link

    description = "Test requests for the application."
  }
  test {
    host    = var.dns_fqdn
    path    = "/dashboard"
    service = google_compute_backend_service.replicated_ui.self_link

    description = "Test requests for install dashboard."
  }
  test {
    host    = var.dns_fqdn
    path    = "/assets/v2-14b7235f2176953201e84392b70d49a4b39d27e51015a3d1a67b0b0d9b4a03f0.css"
    service = google_compute_backend_service.application.self_link

    description = "Test requests for application assets."
  }
  test {
    host    = var.dns_fqdn
    path    = "/assets/03f50a3a6f195be73370626cc2887118.woff"
    service = google_compute_backend_service.replicated_ui.self_link

    description = "Test requests for install dashboard assets."
  }
}

resource "google_compute_target_https_proxy" "application" {
  name             = "${var.prefix}application"
  ssl_certificates = [var.ssl_certificate_self_link]
  url_map          = google_compute_url_map.main.self_link

  description = "The target HTTPS proxy for TFE application traffic."
  ssl_policy  = var.ssl_policy_self_link
}

resource "google_compute_global_forwarding_rule" "application" {
  name   = "${var.prefix}application"
  target = google_compute_target_https_proxy.application.self_link

  description           = "The global forwarding rule for TFE application traffic."
  ip_address            = var.vpc_address
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.vpc_application_tcp_port
}
