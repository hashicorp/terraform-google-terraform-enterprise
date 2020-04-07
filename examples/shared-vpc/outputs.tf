output "application_url" {
  value = module.service.dns.application_url

  description = "The URL of the application."
}

output "console_password" {
  value = module.service.cloud_init.console_password

  description = "The generated password for the management console."
}

output "console_url" {
  value = module.service.primaries.console_url

  description = "The URL of the management console."
}
