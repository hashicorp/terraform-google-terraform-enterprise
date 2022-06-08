# Random String for unique names
# ------------------------------
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

# TFE installation
# ----------------
module "tfe" {
  source = "../../"

  distribution                = "ubuntu"
  dns_create_record           = var.dns_create_record
  dns_zone_name               = var.dns_zone_name
  existing_service_account_id = var.google.service_account
  fqdn                        = var.fqdn
  load_balancer               = "PUBLIC"
  namespace                   = var.namespace
  node_count                  = 2
  ssl_certificate_name        = var.ssl_certificate_name
  tfe_license_secret_id       = module.secrets.license_secret
  vm_machine_type             = "n1-standard-32"
}