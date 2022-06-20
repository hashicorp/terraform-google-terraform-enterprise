provider "google" {
  credentials = try(var.google.credentials, var.google_credentials)
  project     = try(var.google.project, var.google_project)
  region      = try(var.google.region, var.google_region)
  zone        = try(var.google.zone, var.google_zone)
}

provider "google-beta" {
  credentials = try(var.google.credentials, var.google_credentials)
  project     = try(var.google.project, var.google_project)
  region      = try(var.google.region, var.google_region)
  zone        = try(var.google.zone, var.google_zone)
}

provider "tfe" {
  hostname = try(var.tfe.hostname, var.tfe_hostname)
  token    = try(var.tfe.token, var.tfe_token)
}