output "application_url" {
  value = "https://${module.dns.fqdn}/"

  description = "The URL of the application."
}

output "install_dashboard_password" {
  value = module.cloud_init.install_dashboard_password

  description = "The generated password for the install dashboard."
}

output "install_dashboard_url" {
  value = "https://${module.dns.fqdn}:${module.vpc.install_dashboard_tcp_port}/"

  description = "The URL of the install dashboard."
}
