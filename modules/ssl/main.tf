resource "google_compute_managed_ssl_certificate" "main" {
  provider = google-beta

  description = "The managed SSL certificate for the TFE application."
  managed {
    domains = [var.dns_fqdn]
  }
  name = "${var.prefix}cert"
  timeouts {
    create = "30m"
  }
}

resource "google_compute_ssl_policy" "main" {
  name = "${var.prefix}default"

  description     = "The default SSL policy for TFE."
  min_tls_version = "TLS_1_2"
  profile         = "RESTRICTED"
}
