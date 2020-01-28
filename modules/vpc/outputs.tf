output "vpc_name" {
  value = google_compute_network.tfe_vpc.name
}

output "tfe_subnet" {
  value = google_compute_subnetwork.tfe_subnet.name
}

output "subnet_ip_range" {
  value = google_compute_subnetwork.tfe_subnet.ip_cidr_range
}

output "subnet_name" {
  value = google_compute_subnetwork.tfe_subnet.name
}

output "network_url" {
  value = google_compute_network.tfe_vpc.self_link
}

output "subnetwork_url" {
  value = google_compute_network.tfe_vpc.self_link
}

output "subnet" {
  value = google_compute_subnetwork.tfe_subnet
}
