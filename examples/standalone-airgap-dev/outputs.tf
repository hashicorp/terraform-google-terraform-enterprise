# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "login_url" {
  value       = module.tfe.url
  description = "Terraform Enterprise Application URL"
}

output "ptfe_health_check" {
  value       = module.tfe.health_check_url
  description = "Terraform Enterprise Health Check URL"
}

output "replicated_console_password" {
  value       = module.tfe.replicated_console_password
  description = "The password for the TFE console"
}

output "tfe_console_url" {
  value       = module.tfe.replicated_console_url
  description = "Terraform Enterprise Console URL"
}

