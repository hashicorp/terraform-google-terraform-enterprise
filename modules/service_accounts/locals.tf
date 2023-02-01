# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  service_account = var.existing_service_account_id == null ? google_service_account.main[0] : data.google_service_account.main[0]

  member = "serviceAccount:${local.service_account.email}"
}
