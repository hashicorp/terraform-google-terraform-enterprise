# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "health_check_url" {
  value       = module.tfe.health_check_url
  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "iact_notice" {
  value       = "Once deployed, please follow this page to set the initial user up: https://www.terraform.io/docs/enterprise/install/automating-initial-user.html"
  description = "Login advice message."
}

output "iact_url" {
  value       = module.tfe.iact_url
  description = "IACT URL"
}

output "initial_admin_user_url" {
  value       = module.tfe.initial_admin_user_url
  description = "The URL of the initial admin user."
}

output "login_url" {
  value       = module.tfe.url
  description = "The URL for the Terraform Enterprise login."
}

output "tfe_url" {
  value       = module.tfe.url
  description = "The URL of the Terraform Enterprise application."
}

output "database_service_account" {
  value       = google_service_account.tfe_database.email
  description = "The email of the service account used for PostgreSQL IAM authentication."
}