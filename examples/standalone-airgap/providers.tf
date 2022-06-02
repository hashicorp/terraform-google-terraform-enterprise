provider "google" {
  credentials = var.google.credentials
  project     = var.google.project
  region      = var.google.region
  zone        = var.google.zone
}

provider "google-beta" {
  credentials = var.google.credentials
  project     = var.google.project
  region      = var.google.region
  zone        = var.google.zone
}