resource "google_compute_global_forwarding_rule" "https" {
  name       = "${var.prefix}-https"
  ip_address = "${var.publicIP}"
  target     = "${google_compute_target_https_proxy.tfe.self_link}"
  port_range = "443"

  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_target_https_proxy" "tfe" {
  name             = "${var.prefix}-https-proxy"
  url_map          = "${google_compute_url_map.tfe.self_link}"
  ssl_certificates = ["${var.cert}"]
  ssl_policy       = "${var.sslpolicy}"

  #ssl_certificates = ["${file("${path.module}/${var.cert})"]
}
