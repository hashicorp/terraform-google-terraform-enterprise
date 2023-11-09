# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "main" {
  length    = 1
  prefix    = "paa"
  separator = "-"
}

# Store TFE License as secret
# ---------------------------
module "secrets" {
  count  = var.license_file == null || !var.is_replicated_deployment ? 0 : 1
  source = "../../fixtures/secrets"

  license = {
    id   = random_pet.main.id
    path = var.license_file
  }
}

module "tfe" {
  source = "../.."

  consolidated_services_enabled = var.consolidated_services_enabled
  dns_zone_name                 = data.google_dns_managed_zone.main.name
  fqdn                          = "${random_pet.main.id}.${data.google_dns_managed_zone.main.dns_name}"
  namespace                     = random_pet.main.id
  existing_service_account_id   = var.existing_service_account_id
  node_count                    = 2
  tfe_license_secret_id         = try(module.secrets[0].license_secret, data.tfe_outputs.base.values.license_secret_id)

  distribution               = "ubuntu"
  iact_subnet_list           = var.iact_subnet_list
  iact_subnet_time_limit     = 1440
  load_balancer              = "PUBLIC"
  redis_auth_enabled         = false
  redis_version              = "REDIS_7_0"
  ssl_certificate_name       = data.tfe_outputs.base.values.wildcard_ssl_certificate_name
  ssl_private_key_secret     = var.is_replicated_deployment ? null : data.tfe_outputs.base.values.wildcard_ssl_private_key_secret_id
  vm_disk_source_image       = data.google_compute_image.ubuntu.self_link
  vm_machine_type            = "n1-standard-4"
  vm_mig_check_interval_sec  = 300
  vm_mig_healthy_threshold   = 1
  vm_mig_initial_delay_sec   = 3600
  vm_mig_timeout_sec         = 300
  vm_mig_unhealthy_threshold = 10

  labels = {
    oktodelete  = "true"
    terraform   = "true"
    department  = "engineering"
    product     = "terraform-enterprise"
    repository  = "terraform-google-terraform-enterprise"
    description = "public-active-active"
    environment = "test"
    team        = "tf-on-prem"
  }

  # FDO Specific Values
  is_replicated_deployment  = var.is_replicated_deployment
  hc_license                = var.hc_license
  http_port                 = 8080
  https_port                = 8443
  license_reporting_opt_out = true
  registry_password         = var.registry_password
  registry_username         = var.registry_username
  tfe_image                 = "quay.io/hashicorp/terraform-enterprise:${var.tfe_image_tag}"
}
