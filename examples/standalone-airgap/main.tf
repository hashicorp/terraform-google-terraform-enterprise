module "tfe" {
  source = "../../"

  # Air-gap
  tfe_license_bootstrap_airgap_package_path = "/var/lib/ptfe/ptfe.airgap"
  tfe_license_secret_id                     = null

  # Standalone scenario  
  distribution         = "ubuntu"
  dns_zone_name        = var.dns_zone_name
  namespace            = var.namespace
  node_count           = 1
  fqdn                 = var.fqdn
  ssl_certificate_name = var.ssl_certificate_name
  load_balancer        = "PUBLIC"
  vm_disk_source_image = var.vm_disk_source_image

  labels = var.labels

}
