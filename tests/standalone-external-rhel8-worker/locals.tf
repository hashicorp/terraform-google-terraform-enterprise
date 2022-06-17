locals {
  repository_location = "us-west1"
  repository_name     = "terraform-build-worker"
  ssh_user            = "ubuntu"
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
