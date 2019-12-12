output "firewall_name" {
  value = google_compute_firewall.tfe.name
}

output "healthcheck_firewall_name" {
  value = google_compute_firewall.lb-healthchecks.name
}
