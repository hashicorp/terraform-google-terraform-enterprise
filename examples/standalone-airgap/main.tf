# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Run TFE root module for Standalone Airgapped External Mode
# ----------------------------------------------------------
module "tfe" {
  source = "../../"

  gcp_project_id = var.gcp_project_id
  # Air-gap
  existing_service_account_id               = var.existing_service_account_id
  tfe_license_bootstrap_airgap_package_path = "/var/lib/ptfe/ptfe.airgap"
  tfe_license_secret_id                     = null

  # Standalone scenario
  fqdn                 = var.fqdn
  distribution         = "ubuntu"
  dns_zone_name        = var.dns_zone_name
  labels               = var.labels
  load_balancer        = "PUBLIC"
  namespace            = var.namespace
  node_count           = 1
  ssl_certificate_name = var.ssl_certificate_name
  vm_disk_source_image = var.vm_disk_source_image
  vm_machine_type      = "n1-standard-4"
}
