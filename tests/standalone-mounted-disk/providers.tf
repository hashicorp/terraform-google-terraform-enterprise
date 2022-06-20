provider "google" {
  credentials = var.google_credentials
  project     = var.google_project
  region      = var.google_region
  zone        = var.google_zone
}

provider "google-beta" {
  credentials = var.google_credentials
  project     = var.google_project
  region      = var.google_region
  zone        = var.google_zone
}

provider "tfe" {
  hostname = try(var.tfe.hostname, var.tfe_hostname)
  token    = try(var.tfe.token, var.tfe_token)
}
