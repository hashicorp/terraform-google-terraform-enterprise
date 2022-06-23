locals {
  existing_service_account_id = try(var.google.service_account, var.existing_service_account_id)
}