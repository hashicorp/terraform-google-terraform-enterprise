output "network" {
  value = google_compute_network.main

  description = "The network to which resources will be attached."
}

output "subnetwork" {
  value = google_compute_subnetwork.main

  description = "The subnetwork to which resources will be attached."
}
