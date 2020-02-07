provider "google" {
  version = "~> 3.0"

  region  = var.region
  project = var.project
}

provider "google-beta" {
  version = "~> 3.0"

  region  = var.region
  project = var.project
}

provider "random" {
  version = "~> 2.2"
}

provider "template" {
  version = "~> 2.1"
}

module "terraform_enterprise" {
  source  = "hashicorp/terraform-enterprise/google"
  version = "0.1.0"

  credentials  = var.credentials
  dnszone      = var.dnszone
  license_file = var.license_file
  project      = var.project

  region = var.region
}
