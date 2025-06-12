# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "tfe_outputs" "base" {
  organization = try(var.tfe.organization, var.tfe_organization)
  workspace    = try(var.tfe.workspace, var.tfe_workspace)
}

data "google_compute_image" "ubuntu" {
  name    = "ubuntu-2404-noble-amd64-v20250606"
  project = "ubuntu-os-cloud"
}

data "google_dns_managed_zone" "main" {
  name = data.tfe_outputs.base.values.cloud_dns_name
}
