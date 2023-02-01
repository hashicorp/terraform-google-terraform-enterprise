# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  ca_certificate_enabled  = var.ca_certificate != null
  ca_private_key_enabled  = var.ca_private_key != null
  license_enabled         = var.license != null
  ssl_certificate_enabled = var.ssl_certificate != null
  ssl_private_key_enabled = var.ssl_private_key != null
}
