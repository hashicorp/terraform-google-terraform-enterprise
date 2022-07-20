output "replicated_console_password" {
  value       = module.tfe.replicated_console_password
  sensitive   = true
  description = "The password for the TFE console"
}

output "replicated_console_url" {
  value       = module.tfe.replicated_console_url
  description = "Terraform Enterprise Console URL"
}

output "ptfe_endpoint" {
  value       = module.tfe.url
  description = "Terraform Enterprise Application URL"
}

output "health_check_url" {
  value       = module.tfe.health_check_url
  description = "Terraform Enterprise Health Check URL"
}

output "ssh_config_file" {
  value = local.enable_ssh_config != 1 ? "To connect to your instance, use the SSH button in the console" : local_file.ssh_config[0].filename

  description = "The pathname of the SSH configuration file that grants access to the compute instance."
}

output "ssh_private_key" {
  value = local.enable_ssh_config != 1 ? "To connect to your instance, use the SSH button in the console" : local_file.private_key_pem.filename

  description = "The pathname of the private SSH key."
}

output "iact_url" {
  value = module.tfe.iact_url

  description = "The URL of the Terraform Enterprise IACT."
}

output "initial_admin_user_url" {
  value = module.tfe.initial_admin_user_url

  description = "The URL of the Terraform Enterprise initial admin user."
}

output "ptfe_health_check" {
  value       = module.tfe.health_check_url
  description = "Terraform Enterprise Health Check URL"
}

output "tfe_url" {
  value       = module.tfe.url
  description = "Terraform Enterprise Application URL"
}

