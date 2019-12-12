resource "google_compute_managed_ssl_certificate" "frontendcert" {
  provider = google-beta

  name = "cert"

  managed {
    domains = [var.domain_name]
  }

  timeouts {
    create = "30m"
  }
}
