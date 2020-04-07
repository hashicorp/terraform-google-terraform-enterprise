output "application_forwarding_rule" {
  value = google_compute_global_forwarding_rule.application

  description = "The global forwarding rule for application traffic."
}
