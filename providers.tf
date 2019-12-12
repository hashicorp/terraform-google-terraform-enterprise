provider "google" {
  project     = var.project
  region      = var.region
  credentials = file(var.credentials)
}

provider "google-beta" {
  project     = var.project
  region      = var.region
  credentials = file(var.credentials)
}

