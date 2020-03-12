output "application_url" {
  value = "https://${module.dns.fqdn}"
}

output "console_url" {
  value = module.primary_cluster.console_url

  description = "The URL of the management console."
}

output "dashboard_password" {
  value = module.cluster-config.console_password
}
