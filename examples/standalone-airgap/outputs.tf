output "health_check_url" {
  value       = module.tfe.health_check_url
  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "lb_address" {
  value       = module.tfe.lb_address
  description = "Load Balancer Address"
}

output "login_url" {
  value       = module.tfe.url
  description = "Login URL to setup the TFE instance once it is initialized"
}

output "replicated_console_password" {
  value       = module.tfe.replicated_console_password
  description = "Generated password for replicated dashboard"
}

output "tfe_console_url" {
  value       = module.tfe.replicated_console_url
  description = "Terraform Enterprise Console URL"
}
