output "subnetwork" {
  value = google_compute_subnetwork.tfe_subnet.self_link

  description = "The self link of the subnetwork."
}
output "network" {
  value = google_service_networking_connection.private_vpc_connection.network

  description = "The self link of the network."
}
