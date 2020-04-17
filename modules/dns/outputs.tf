output "application_url" {
  value = local.application_url

  description = "The URL of the application."
}

output "fqdn" {
  value = local.fqdn

  description = "The fully qualified domain name of the application."
}

output "install_dashboard_url" {
  value = "${local.application_url}/dashboard"

  description = "The URL of the install dashboard."
}
