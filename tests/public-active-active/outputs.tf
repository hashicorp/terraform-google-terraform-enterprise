output "health_check_url" {
  value = module.tfe.health_check_url

  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "tfe" {
  value = module.tfe

  description = "The Terraform Enterprise deployment."
}
