output "certificate" {
  value = google_compute_managed_ssl_certificate.main

  description = "The managed SSL certificate for the application."
}

output "policy" {
  value = google_compute_ssl_policy.main

  description = "The default SSL policy for the application."
}
