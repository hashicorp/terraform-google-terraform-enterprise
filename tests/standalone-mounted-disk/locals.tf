# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  labels = {
    department  = "engineering"
    description = "standalone-mounted-disk-scenario"
    environment = random_pet.main.id
    oktodelete  = "true"
    product     = "terraform-enterprise"
    repository  = "hashicorp-terraform-google-terraform-enterprise"
    team        = "terraform-enterprise"
  }

  enable_ssh_config = var.license_file == null ? 0 : 1
  registry          = "quay.io"
  ssh_user          = "ubuntu"
}
