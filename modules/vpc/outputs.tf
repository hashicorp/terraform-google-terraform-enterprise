output "network" {
  value = google_compute_network.tfe_vpc

  description = "The network to which resources will be attached."
}

output "subnetwork" {
  value = google_compute_subnetwork.tfe_subnet

  description = "The subnetwork to which resources will be attached."
}
