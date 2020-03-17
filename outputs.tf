output "application_url" {
  value = "https://${module.dns.fqdn}"
}

output "console_password" {
  value = module.cloud_init.console_password

  description = "The generated password for the management console."
}

output "console_url" {
  value = module.primary_cluster.console_url

  description = "The URL of the management console."
}
