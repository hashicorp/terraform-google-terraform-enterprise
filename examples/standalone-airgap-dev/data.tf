# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "google_dns_managed_zone" "main" {
  name = var.dns_zone_name
}
