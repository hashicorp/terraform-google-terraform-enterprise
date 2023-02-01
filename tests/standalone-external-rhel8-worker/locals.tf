# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  repository_location = "us-west1"
  repository_name     = "terraform-build-worker"
  ssh_user            = "ubuntu"
  enable_ssh_config   = length(var.license_file) > 0 ? 1 : 0
}
