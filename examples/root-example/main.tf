provider "google" {
  version = "3.2.0"
}

provider "google-beta" {
  version = "3.2.0"
}

provider "random" {
  version = "2.1.0"
}

provider "template" {
  version = "2.1.0"
}

locals {
  prefix_length = 1
}

resource "random_pet" "prefix" {
  keepers = {
    length = local.prefix_length
  }
  length    = local.prefix_length
  prefix    = "tfe"
  separator = "-"
}

module "terraform_enterprise" {
  source  = "hashicorp/terraform-enterprise/google"
  version = "0.1.0"

  cloud_init_license_file   = var.cloud_init_license_file
  dns_managed_zone          = var.dns_managed_zone
  dns_managed_zone_dns_name = var.dns_managed_zone_dns_name

  prefix = "${random_pet.prefix.id}-"
}
