output "reserve_subnetwork" {
  value = google_compute_subnetwork.reserve

  description = "The reserve subnetwork for private load balancing."
}

output "subnetwork" {
  value = google_compute_subnetwork.tfe_subnet

  description = "The subnetwork."
}

output "network" {
  value = google_compute_network.tfe_vpc

  description = "The network."
}
