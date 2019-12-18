output "installer_dashboard_url" {
  description = "The URL to access the installer dashboard."
  value       = "https://${google_compute_instance.primary[0].network_interface[0].access_config[0].nat_ip}:8800"
}

output "application_endpoints" {
  description = "Network Endpoints Group that for the application services"
  value       = google_compute_network_endpoint_group.https.self_link
}

output "cluster_api_endpoint" {
  description = "Internal address of the cluster api address used for internal communication"
  value       = module.internal_lb.address
}

output "application_addresses" {
  description = "IP addresses of primaries that are running the application on port 443"
  value       = [for primary in google_compute_instance.primary.* : primary.network_interface.0.network_ip]
}
output "primary_external_addresses" {
  description = "External IP addresses of primaries for updating DNS"

  value = [for primary in google_compute_instance.primary.* : {
    hostname = primary.name,
    address  = primary.network_interface.0.access_config.0.nat_ip,
  }]
}
