# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  member = "serviceAccount:${var.service_account.email}"
}
