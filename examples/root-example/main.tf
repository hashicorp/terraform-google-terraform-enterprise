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

module "tfe-cluster" {
  source  = "hashicorp/terraform-enterprise/google"
  version = "0.1.0"

  credentials  = var.credentials
  dnszone      = var.dnszone
  license_file = var.license_file
  project      = var.project

  region = var.region
}
