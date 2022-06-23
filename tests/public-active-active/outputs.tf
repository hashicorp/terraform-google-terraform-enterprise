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

output "tfe" {
  value = module.tfe
  sensitive = true
  description = "The Terraform Enterprise deployment."
}

output "tfe_url" {
  value = module.tfe.url

  description = "The URL of Terraform Enterprise."
}
