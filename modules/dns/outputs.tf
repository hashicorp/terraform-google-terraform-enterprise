output "application_url" {
  value = "https://${local.fqdn}"

  description = "The URL of the application."
}

output "fqdn" {
  value = local.fqdn

  description = "The fully qualified domain name of the application."
}
