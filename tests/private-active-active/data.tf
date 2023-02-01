# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "tfe_outputs" "base" {
  organization = try(var.tfe.organization, var.tfe_organization)
  workspace    = try(var.tfe.workspace, var.tfe_workspace)
}

data "google_dns_managed_zone" "main" {
  name = data.tfe_outputs.base.values.cloud_dns_name
}

data "google_compute_image" "rhel" {
  name    = "rhel-7-v20220519"
  project = "rhel-cloud"
}

data "google_compute_image" "ubuntu" {
  name    = "ubuntu-2004-focal-v20220118"
  project = "ubuntu-os-cloud"
}
