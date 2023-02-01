# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "credentials" {
  value = base64decode(google_service_account_key.key.private_key)

  description = "The private key of the service account."
}
output "service_account" {
  value = var.existing_service_account_id == null ? google_service_account.main[0] : data.google_service_account.main[0]

  description = "The service account."
}
