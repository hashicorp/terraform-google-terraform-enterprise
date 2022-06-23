resource "random_pet" "main" {
  length    = 1
  prefix    = "paa"
  separator = "-"
}

module "tfe" {
  source = "../.."

  dns_zone_name               = data.google_dns_managed_zone.main.name
  fqdn                        = "public-active-active.${data.google_dns_managed_zone.main.dns_name}"
  namespace                   = random_pet.main.id
  existing_service_account_id = local.existing_service_account_id
  node_count                  = 2
  tfe_license_secret_id       = data.tfe_outputs.base.values.license_secret_id
  ssl_certificate_name        = data.tfe_outputs.base.values.wildcard_ssl_certificate_name
  distribution                = "ubuntu"
  iact_subnet_list            = var.iact_subnet_list
  iact_subnet_time_limit      = 1440
  load_balancer               = "PUBLIC"
  redis_auth_enabled          = false
  vm_disk_source_image        = data.google_compute_image.ubuntu.self_link
  vm_machine_type             = "n1-standard-4"

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
}
