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

module "tfe-cluster" {
  source = "../.."

  credentials  = var.credentials
  dnszone      = var.dnszone
  license_file = var.license_file
  project      = var.project

  region = var.region
}
