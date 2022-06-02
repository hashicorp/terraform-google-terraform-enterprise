# Run TFE root module for Standalone Airgapped External Mode
# ----------------------------------------------------------
module "tfe" {
  source = "../../"

  # Air-gap
  existing_service_account_id               = var.google.service_account
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
