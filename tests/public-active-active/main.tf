resource "random_pet" "main" {
  length    = 2
  prefix    = "paa"
  separator = "-"
}
data "google_compute_image" "ubuntu" {
  name = "ubuntu-2004-focal-v20210211"

  project = "ubuntu-os-cloud"
}

module "tfe" {
  source = "../.."

  dns_zone_name        = var.dns_zone_name
  namespace            = random_pet.main.id
  node_count           = 2
  tfe_license_name     = "startup.rli"
  tfe_license_path     = var.tfe_license_path
  ssl_certificate_name = var.ssl_certificate_name

  iact_subnet_list     = var.iact_subnet_list
  load_balancer        = "PUBLIC"
  redis_auth_enabled   = false
  vm_disk_source_image = data.google_compute_image.ubuntu.self_link
  vm_machine_type      = "n1-standard-4"
}
