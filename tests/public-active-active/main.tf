resource "random_pet" "main" {
  length    = 1
  prefix    = "paa"
  separator = "-"
}

data "google_dns_managed_zone" "main" {
  name = var.dns_zone_name
}

data "google_compute_image" "ubuntu" {
  name = "ubuntu-2004-focal-v20210211"

  project = "ubuntu-os-cloud"
}

module "tfe" {
  source = "../.."

  dns_zone_name        = var.dns_zone_name
  fqdn                 = "public-active-active.${trimsuffix(data.google_dns_managed_zone.main.dns_name, ".")}"
  namespace            = random_pet.main.id
  node_count           = 2
  license_secret       = var.license_secret
  ssl_certificate_name = var.ssl_certificate_name

  iact_subnet_list       = concat(var.iact_subnet_list, ["172.19.0.0/16"])
  iact_subnet_time_limit = 1440
  load_balancer          = "PUBLIC"
  redis_auth_enabled     = false
  vm_disk_source_image   = data.google_compute_image.ubuntu.self_link
  vm_machine_type        = "n1-standard-4"
}
