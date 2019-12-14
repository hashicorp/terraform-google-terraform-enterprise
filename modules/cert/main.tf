resource "google_compute_managed_ssl_certificate" "frontendcert" {
  provider = google-beta

  name = "${var.prefix}-cert-${var.install_id}"

  managed {
    domains = [var.domain_name]
  }

  timeouts {
    create = "30m"
  }
}
