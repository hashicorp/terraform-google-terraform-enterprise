# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "tfe_outputs" "base" {
  organization = try(var.tfe.organization, var.tfe_organization)
  workspace    = try(var.tfe.workspace, var.tfe_workspace)
}

data "google_dns_managed_zone" "main" {
  name = data.tfe_outputs.base.values.cloud_dns_name
}

data "google_compute_image" "ubuntu" {
  name    = "ubuntu-2004-focal-v20210211"
  project = "ubuntu-os-cloud"
}

data "google_compute_region_instance_group" "tfe" {
  count     = local.enable_ssh_config
  self_link = null_resource.wait_for_instances[count.index].triggers.self_link
}

data "google_compute_instance" "tfe" {
  count     = local.enable_ssh_config
  self_link = data.google_compute_region_instance_group.tfe[count.index].instances[0].instance
}

# This null_data_source is used to prevent Terraform from trying to render local_file.ssh_config file before data.
# google_compute_instance.tfe is available.
# See https://github.com/hashicorp/terraform-provider-local/issues/57
data "null_data_source" "instance" {
  count = local.enable_ssh_config
  inputs = {
    name       = data.google_compute_instance.tfe[0].name
    network_ip = data.google_compute_instance.tfe[0].network_interface[0].network_ip
    project    = data.google_compute_instance.tfe[0].project
    zone       = data.google_compute_instance.tfe[0].zone
  }
}
