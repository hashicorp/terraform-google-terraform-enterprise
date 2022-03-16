output "replicated_console_password" {
  value       = module.tfe.replicated_console_password
  description = "Generated password for replicated dashboard"
}

output "lb_address" {
  value       = module.tfe.lb_address
  description = "Load Balancer Address"
}

output "health_check_url" {
  value       = module.tfe.health_check_url
  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "iact_url" {
  value       = module.tfe.iact_url
  description = "IACT URL"
}

output "initial_admin_user_url" {
  value       = module.tfe.initial_admin_user_url
  description = "Initial Admin user URL"
}

output "url" {
  value       = module.tfe.url
  description = "Login URL to setup the TFE instance once it is initialized"
}