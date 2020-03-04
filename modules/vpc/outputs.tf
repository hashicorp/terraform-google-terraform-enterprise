output "vpc_name" {
  value = google_compute_network.tfe_vpc.name
}

output "network_url" {
  value = google_compute_network.tfe_vpc.self_link
}

output "subnetwork" {
  value = google_compute_subnetwork.main
}
