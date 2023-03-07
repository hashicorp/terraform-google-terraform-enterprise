# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  repository_name   = "terraform-build-worker"
  ssh_user          = "ubuntu"
  enable_ssh_config = length(var.license_file) > 0 ? 1 : 0

  project_regions = {
    "hc-50fbe27799384c96925f18084d7" = "us-west1"
    "tfe-modules-ci-001"             = "us-east4"
  }
  repository_location = local.project_regions[data.google_project.project.project_id]
}