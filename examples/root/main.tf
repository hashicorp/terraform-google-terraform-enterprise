provider "google" {
  version = "3.21.0"
}

provider "google-beta" {
  version = "3.21.0"
}

provider "random" {
  version = "2.1.0"
}

provider "template" {
  version = "2.1.0"
}

module "terraform_enterprise" {
  source = "../.."

  dns_managed_zone          = var.dns_managed_zone
  dns_managed_zone_dns_name = var.dns_managed_zone_dns_name
  license_url               = var.license_url

  prefix = var.prefix
}
