locals {
  labels = {
    department  = "engineering"
    description = "standalone-mounted-disk-scenario-deployed-from-circleci"
    environment = random_pet.main.id
    oktodelete  = "true"
    product     = "terraform-enterprise"
    repository  = "hashicorp-terraform-google-terraform-enterprise"
    team        = "terraform-enterprise-on-prem"
    terraform   = "true"
  }
  ssh_user = "ubuntu"
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
