# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "main" {
  length    = 1
  prefix    = "ptaa"
  separator = "-"
}

module "test_proxy" {
  source = "../../fixtures/test_proxy"

  instance_image              = data.google_compute_image.ubuntu.id
  name                        = local.name
  network                     = module.tfe.network
  subnetwork                  = module.tfe.subnetwork
  existing_service_account_id = var.existing_service_account_id

  labels                          = local.labels
  mitmproxy_ca_certificate_secret = data.tfe_outputs.base.values.ca_certificate_secret_id
  mitmproxy_ca_private_key_secret = data.tfe_outputs.base.values.ca_private_key_secret_id
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

  bypass_preflight_checks       = true
  consolidated_services_enabled = var.consolidated_services_enabled
  distribution                  = "rhel"
  dns_zone_name                 = data.google_dns_managed_zone.main.name
  fqdn                          = "${random_pet.main.id}.${data.google_dns_managed_zone.main.dns_name}"
  namespace                     = random_pet.main.id
  existing_service_account_id   = var.existing_service_account_id
  node_count                    = 2
  tfe_license_secret_id         = try(module.secrets[0].license_secret, data.tfe_outputs.base.values.license_secret_id)
  labels                        = local.labels
  ca_certificate_secret_id      = data.tfe_outputs.base.values.ca_certificate_secret_id
  iact_subnet_list              = ["${module.test_proxy.compute_instance.network_interface[0].network_ip}/32"]
  iact_subnet_time_limit        = 1440
  load_balancer                 = "PRIVATE_TCP"
  proxy_ip                      = module.test_proxy.proxy_ip
  proxy_port                    = module.test_proxy.proxy_port
  redis_auth_enabled            = true
  redis_version                 = "REDIS_7_0"
  ssl_certificate_secret        = data.tfe_outputs.base.values.wildcard_ssl_certificate_secret_id
  ssl_private_key_secret        = data.tfe_outputs.base.values.wildcard_ssl_private_key_secret_id
  tls_bootstrap_cert_pathname   = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname    = "/var/lib/terraform-enterprise/key.pem"
  vm_disk_source_image          = data.google_compute_image.rhel.self_link
  vm_machine_type               = "n1-standard-32"
  vm_mig_check_interval_sec     = 300
  vm_mig_healthy_threshold      = 1
  vm_mig_initial_delay_sec      = 3600
  vm_mig_timeout_sec            = 300
  vm_mig_unhealthy_threshold    = 10

  # FDO Specific Values
  is_replicated_deployment  = var.is_replicated_deployment
  hc_license                = var.hc_license
  http_port                 = 8080
  https_port                = 8443
  license_reporting_opt_out = true
  registry                  = local.registry
  registry_password         = var.registry_password
  registry_username         = var.registry_username
  tfe_image                 = "${local.registry}/hashicorp/terraform-enterprise:${var.tfe_image_tag}"
}

