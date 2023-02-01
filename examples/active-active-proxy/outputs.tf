# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "health_check_url" {
  value       = module.active_active_proxy.health_check_url
  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "iact_url" {
  value       = module.active_active_proxy.iact_url
  description = "The URL of the Terraform Enterprise IACT."
}

output "login_url" {
  value       = module.active_active_proxy.url
  description = "The URL to the TFE application."
}

output "proxy_instance_name" {
  value       = module.test_proxy.compute_instance.name
  description = "The name of the HTTP proxy compute instance."
}

output "proxy_instance_zone" {
  value       = module.test_proxy.compute_instance.zone
  description = "The zone of the HTTP proxy compute instance."
}

output "active_active_proxy_url" {
  value       = module.active_active_proxy.url
  description = "The URL of Terraform Enterprise."
}