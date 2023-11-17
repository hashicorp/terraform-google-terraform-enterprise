# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  name = "${random_pet.main.id}-proxy"
  labels = {
    oktodelete  = "true"
    department  = "engineering"
    product     = "terraform-enterprise"
    repository  = "terraform-google-terraform-enterprise"
    description = "private-tcp-active-active"
    environment = "test"
    team        = "terraform-enterprise"
  }

  registry = "quay.io"
}
