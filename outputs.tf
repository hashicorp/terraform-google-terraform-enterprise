output "installer_dashboard_password" {
  value       = "${random_pet.console_password.id}"
  description = "The password to access the installer dashboard."
}

output "installer_dashboard_url" {
  value       = "https://${google_compute_instance.primary.0.network_interface.0.access_config.0.nat_ip}:8800"
  description = "The URL to access the installer dashboard."
}

output "primary_public_ip" {
  value       = "${var.public_ip}"
  description = "The Public IP for the load balancer to use."
}

output "application_endpoint" {
  value       = "https://${var.frontend_dns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}"
  description = "The URI to access the Terraform Enterprise Application."
}

output "application_health_check" {
  value       = "https://${var.frontend_dns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}/_health_check"
  description = "The URI for the Terraform Enterprise Application health check."
}
