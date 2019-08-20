output "replicated_console_password" {
  value = "${random_pet.console_password.id}"
}

output "replicated_console_url" {
  value = "https://${google_compute_instance.primary.0.network_interface.0.access_config.0.nat_ip}:8800"
}

/*output "replicated_console_url" {
  value = "https://${var.frontend_dns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}/dashboard"
}*/

output "primary_public_ip" {
  value = "${var.public_ip}"
}

output "ptfe_endpoint" {
  value = "https://${var.frontend_dns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}"
}

output "ptfe_health_check" {
  value = "https://${var.frontend_dns}.${substr(data.google_dns_managed_zone.dnszone.dns_name, 0, length(data.google_dns_managed_zone.dnszone.dns_name) - 1)}/_health_check"
}
