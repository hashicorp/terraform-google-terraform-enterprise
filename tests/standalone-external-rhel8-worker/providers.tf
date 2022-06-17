provider "google" {
  credentials = try(var.google.credentials, local.google.credentials)
  project     = try(var.google.project, local.google.project)
  region      = try(var.google.region, local.google.region)
  zone        = try(var.google.zone, local.google.zone)
}

provider "google-beta" {
  credentials = try(var.google.credentials, local.google.credentials)
  project     = try(var.google.project, local.google.project)
  region      = try(var.google.region, local.google.region)
  zone        = try(var.google.zone, local.google.zone)
}

provider "tfe" {
  hostname = try(var.tfe.hostname, local.tfe.hostname)
  token    = try(var.tfe.token, local.tfe.token)
}