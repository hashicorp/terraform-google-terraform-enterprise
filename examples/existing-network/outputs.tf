output "health_check_url" {
  value       = module.existing_network.health_check_url
  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "iact_notice" {
  value       = "Once deployed, please follow this page to set the initial user up: https://www.terraform.io/docs/enterprise/install/automating-initial-user.html"
  description = "Login advice message."
}

output "replicated_console_password" {
  value       = module.existing_network.replicated_console_password
  description = "Generated password for replicated dashboard"
}

output "lb_address" {
  value       = module.existing_network.lb_address
  description = "Load Balancer Address"
}

output "login_url" {
  value       = module.existing_network.url
  description = "The URL to the TFE application."
}