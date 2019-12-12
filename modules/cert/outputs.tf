output "certificate" {
  value = "${google_compute_managed_ssl_certificate.frontendcert.self_link}"
}
