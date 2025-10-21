# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "credentials" {
  value = var.existing_service_account_id == null ? base64decode(google_service_account_key.key[0].private_key) : ""

  description = "The private key of the service account. Empty when using an existing service account."
}
output "service_account" {
  value = var.existing_service_account_id == null ? google_service_account.main[0] : data.google_service_account.main[0]

  description = "The service account."
}
