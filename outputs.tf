output "installer_dashboard_url" {
  value = "https://${google_compute_instance.primary.0.network_interface.0.access_config.0.nat_ip}:8800"
  description = "URL to access the Installer Dashboard."
}

output "installer_dashboard_password" {
  value = "${random_pet.console_password.id}"
  description = "Password for the Installer Dashboard."
}

/*output "replicated_console_url" {
  value = "https://${var.frontenddns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}/dashboard"
}*/

output "primary_public_ip" {
  value = "${var.publicip}"
  description = "Front end IP for the load balancer."
}

output "tfe_endpoint" {
  value = "https://${var.frontenddns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}"
  description = "Application URL"
}

output "tfe_health_check" {
  value = "https://${var.frontenddns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}/_health_check"
  description = "Health Check URL"
}