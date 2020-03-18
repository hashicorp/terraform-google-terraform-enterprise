output "application_url" {
  value = module.dns.application_url

  description = "The URL of the application."
}

output "console_password" {
  value = module.cloud_init.console_password

  description = "The generated password for the management console."
}

output "console_url" {
  value = module.primary_cluster.console_url

  description = "The URL of the management console."
}
