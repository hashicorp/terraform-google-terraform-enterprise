
output "lb_address" {
  value       = module.tfe.lb_address
  description = "Load Balancer Address"
}

output "health_check_url" {
  value       = module.tfe.health_check_url
  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "url" {
  value       = module.tfe.url
  description = "Login URL to setup the TFE instance once it is initialized"
}

output "iact_url" {
  value       = module.tfe.iact_url
  description = "IACT URL"
}

output "initial_admin_user_url" {
  value       = module.tfe.initial_admin_user_url
  description = "Initial Admin user URL"
}

# output "network" {
#   value       = module.tfe.network
#   description = "The network to which TFE is attached."
# }

# output "service_account_email" {
#   value       = module.tfe.service_account_email
#   description = "The email address of the service account associated with the TFE instance."
# }

# output "subnetwork" {
#   value       = module.tfe.subnetwork
#   description = "The subnetwork to which TFE is attached."
# }

output "dns_configuration_notice" {
  value       = "If you are using external DNS, please make sure to create a DNS record using the lb_address output that has been provided"
  description = "A warning message."
}

output "iact_notice" {
  value       = "Once deployed, please follow this page to set the initial user up: https://www.terraform.io/docs/enterprise/install/automating-initial-user.html"
  description = "Login advice message."
}
