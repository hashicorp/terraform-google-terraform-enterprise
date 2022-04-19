resource "random_pet" "main" {
  length = 1
}

module "secrets" {
  source = "../../fixtures/secrets"

  license = {
    id   = random_pet.main.id
    path = var.license_file
  }
}

module "tfe" {
  source = "../../"

  # Bootstrapping Air-gap prerequisites
  airgap_url                                = var.airgap_url
  tfe_license_bootstrap_airgap_package_path = "/var/lib/ptfe/ptfe.airgap"
  tfe_license_secret_id                     = module.secrets.license_secret

  # Standalone scenario  
  distribution         = "ubuntu"
  namespace            = var.namespace
  node_count           = 1
  fqdn                 = var.fqdn
  ssl_certificate_name = var.ssl_certificate_name
  dns_zone_name        = var.dns_zone_name
  load_balancer        = "PUBLIC"

  labels = var.labels

}
