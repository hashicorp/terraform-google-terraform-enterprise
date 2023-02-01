# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "replicated_console_password" {
  value       = module.settings.replicated_configuration.DaemonAuthenticationPassword
  description = "Generated password for replicated dashboard"
}

output "replicated_console_url" {
  value       = local.replicated_console_url
  description = "The URL of the Terraform Enterprise administration console."
}

output "lb_address" {
  value       = local.lb_address
  description = "Load Balancer Address"
}

output "health_check_url" {
  value = "${local.base_url}_health_check"

  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "iact_url" {
  value = "${local.base_url}admin/retrieve-iact"

  description = "The URL of the Terraform Enterprise initial admin creation token."
}

output "initial_admin_user_url" {
  value = "${local.base_url}admin/initial-admin-user"

  description = "The URL of the Terraform Enterprise initial admin user."
}

output "url" {
  value = local.base_url

  description = "The URL of Terraform Enterprise."
}

output "network" {
  value       = try(module.networking[0].network, null)
  description = "The network to which TFE is attached."
}

output "service_account" {
  value       = module.service_accounts.service_account
  description = "The service account associated with the TFE instance."
}

output "subnetwork" {
  value       = try(module.networking[0].subnetwork, null)
  description = "The subnetwork to which TFE is attached."
}

output "dns_configuration_notice" {
  value       = "If you are using external DNS, please make sure to create a DNS record using the lb_address output that has been provided"
  description = "A warning message."
}

output "vm_mig" {
  value = module.vm_mig

  description = "The managed instance group module."
}
