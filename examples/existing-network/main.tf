resource "random_pet" "main" {
  length = 1
}

# Store TFE License as secret
# ---------------------------
module "secrets" {
  source = "../../fixtures/secrets"

  license = {
    id   = random_pet.main.id
    path = var.license_file
  }
}

# TFE installation into an existing network
# -----------------------------------------
module "existing_network" {
  source = "../../"

  distribution                = "ubuntu"
  dns_zone_name               = var.dns_zone_name
  existing_service_account_id = var.existing_service_account_id
  fqdn                        = var.fqdn
  labels                      = var.labels
  load_balancer               = "PUBLIC"
  namespace                   = var.namespace
  network                     = var.network
  node_count                  = var.node_count
  ssl_certificate_name        = var.ssl_certificate_name
  subnetwork                  = var.subnetwork
  tfe_license_secret_id       = module.secrets.license_secret
  vm_machine_type             = "n1-standard-32"
}
