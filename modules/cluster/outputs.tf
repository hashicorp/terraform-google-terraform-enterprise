output "installer_dashboard_url" {
  description = "The URL to access the installer dashboard."
  # This conditional logic prevents an invalid index error when the value is evaluated after
  # google_compute_instance.primary is destroyed. An example of this scenario is when a destroy process is resumed
  # after recovering from an error.
  value = length(google_compute_instance.primary) > 0 ? (
    "https://${google_compute_instance.primary[0].network_interface[0].access_config[0].nat_ip}:8800"
  ) : ""
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

output "primary_instance_group" {
  value = google_compute_instance_group.primary

  description = "The primary compute instance group."
}

output "secondary_region_instance_group_manager" {
  value = google_compute_region_instance_group_manager.secondary

  description = "The secondary compute regional instance group manager."
}
