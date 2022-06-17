locals {
  name = "${random_pet.main.id}-proxy"

  tfe = {
    hostname     = var.tfe_hostname
    organization = var.tfe_organization
    token        = var.tfe_token
    workspace    = var.tfe_workspace
  }

  google = {
    credentials = var.google_credentials
    project     = var.google_project
    region      = var.google_region
    zone        = var.google_zone
  }

  labels = {
    oktodelete  = "true"
    terraform   = "true"
    department  = "engineering"
    product     = "terraform-enterprise"
    repository  = "terraform-google-terraform-enterprise"
    description = "private-active-active"
    environment = "test"
    team        = "tf-on-prem"
  }
}
