# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "tfe" {
  hostname = try(var.tfe.hostname, var.tfe_hostname)
  token    = try(var.tfe.token, var.tfe_token)
}
