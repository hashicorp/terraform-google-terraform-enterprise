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

  credentials  = "auth-file-123456678.json"
  dnszone      = "example"
  license_file = "customer.rli"
  project      = var.project

  region = var.region
}
