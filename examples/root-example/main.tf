provider "google" {
  version = "3.1.0"
}

provider "google-beta" {
  version = "3.0.0"
}

provider "random" {
  version = "2.1.0"
}

provider "template" {
  version = "2.1.0"
}

resource "random_pet" "main" {
  length    = 2
  prefix    = "tfe"
  separator = "-"
}

module "terraform_enterprise" {

  cloud_init_license_file   = var.cloud_init_license_file
  dns_managed_zone          = var.dns_managed_zone
  dns_managed_zone_dns_name = var.dns_managed_zone_dns_name

  prefix = "${random_pet.main.id}-"
}
