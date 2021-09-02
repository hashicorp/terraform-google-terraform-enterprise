output "health_check_url" {
  value = module.tfe.health_check_url

  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "iact_url" {
  value = module.tfe.iact_url

  description = "The URL of the Terraform Enterprise IACT."
}

output "initial_admin_user_url" {
  value = module.tfe.initial_admin_user_url

  description = "The URL of the Terraform Enterprise initial admin user."
}

output "proxy_instance_name" {
  value = google_compute_instance.http_proxy.name

  description = "The name of the HTTP proxy compute instance."
}

output "proxy_instance_zone" {
  value = google_compute_instance.http_proxy.zone

  description = "The zone of the HTTP proxy compute instance."
}

output "tfe" {
  value = module.tfe

  description = "The Terraform Enterprise deployment."
}

output "tfe_url" {
  value = module.tfe.url

  description = "The URL of Terraform Enterprise."
}
