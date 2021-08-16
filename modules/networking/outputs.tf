output "subnetwork" {
  value = google_compute_subnetwork.tfe_subnet

  description = "The subnetwork."
}

output "network" {
  value = google_compute_network.tfe_vpc

  description = "The network."
}
