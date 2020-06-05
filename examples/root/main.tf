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
  source = "github.com/hashicorp/terraform-google-terraform-enterprise?ref=internal-preview"

  cloud_init_license_file   = var.cloud_init_license_file
  dns_managed_zone          = var.dns_managed_zone
  dns_managed_zone_dns_name = var.dns_managed_zone_dns_name

  prefix = var.prefix
}
