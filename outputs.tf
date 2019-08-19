output "installer_dashboard_password" {
  value = "${random_pet.console_password.id}"
}

output "installer_dashboard_url" {
  value = "https://${google_compute_instance.primary.0.network_interface.0.access_config.0.nat_ip}:8800"
}

/*output "replicated_console_url" {
  value = "https://${var.frontenddns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}/dashboard"
}*/

output "primary_public_ip" {
  value = "${var.publicip}"
}

output "tfe_endpoint" {
  value = "https://${var.frontenddns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}"
}

output "tfe_health_check" {
  value = "https://${var.frontenddns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}/_health_check"
}