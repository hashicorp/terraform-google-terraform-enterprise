output "application_url" {
  value = module.dns.application_url

  description = "The URL of the application."
}

output "install_dashboard_password" {
  value = module.cloud_init.install_dashboard_password

  description = "The generated password for the install dashboard."
}

output "install_dashboard_url" {
  value = module.dns.install_dashboard_url

  description = "The URL of the install dashboard."
}
