locals {
  tfe = {
    hostname     = var.tfe_hostname
    organization = var.tfe_organization
    token        = var.tfe_token
    workspace    = var.workspace
  }

  google = {
    credentials = var.google_credentials
    project     = var.google_project
    region      = var.google_region
    zone        = var.google_zone
  }
}
