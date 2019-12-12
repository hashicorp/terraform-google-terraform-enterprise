output "vpc" {
  value = "${google_compute_network.tfe_vpc.name}"
}

output "tfe_subnet" {
  value = "${google_compute_subnetwork.tfe_subnet.name}"
}

output "tfe_firewall" {
  value = "${google_compute_firewall.tfe.name}"
}

output "tfe_healthchk_firewall" {
  value = "${google_compute_firewall.lb-healthchecks.name}"
}

output "google_compute_network_url" {
  value = "${google_compute_network.tfe_vpc.self_link}"
}
