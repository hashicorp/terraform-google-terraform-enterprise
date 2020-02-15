output "application_forwarding_rule" {
  value = google_compute_global_forwarding_rule.application

  description = "The global forwarding rule for application traffic."
}

output "address" {
  value = google_compute_global_address.main.address
}

output "replicated_forwarding_rule" {
  value = google_compute_global_forwarding_rule.replicated

  description = "The global forwarding rule for Replicated traffic."
}
