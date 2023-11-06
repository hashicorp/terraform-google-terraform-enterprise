# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  labels = {
    department  = "engineering"
    description = "standalone-mounted-disk-scenario-deployed-from-circleci"
    environment = random_pet.main.id
    oktodelete  = "true"
    product     = "terraform-enterprise"
    repository  = "hashicorp-terraform-google-terraform-enterprise"
    team        = "terraform-enterprise-on-prem"
    terraform   = "true"
  }
  ssh_user          = "ubuntu"
  enable_ssh_config = var.license_file == null ? 0 : 1
}
