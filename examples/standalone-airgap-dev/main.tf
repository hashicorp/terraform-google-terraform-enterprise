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

# Standalone Airgapped - DEV (bootstrap prerequisites)
# ----------------------------------------------------
module "tfe" {
  source = "../.."

  airgap_url                                = var.airgap_url
  tfe_license_bootstrap_airgap_package_path = "/var/lib/ptfe/ptfe.airgap"

  distribution                = "ubuntu"
  dns_zone_name               = var.dns_zone_name
  fqdn                        = "${random_pet.main.id}.${trimsuffix(data.google_dns_managed_zone.main.dns_name, ".")}"
  namespace                   = random_pet.main.id
  node_count                  = 1
  tfe_license_secret_id       = module.secrets.license_secret
  ssl_certificate_name        = var.ssl_certificate_name
  existing_service_account_id = var.google.service_account
  iact_subnet_list            = ["0.0.0.0/0"]
  iact_subnet_time_limit      = 60
  labels                      = var.labels
  load_balancer               = "PUBLIC"
  operational_mode            = "external"
  vm_machine_type             = "n1-standard-4"
}
