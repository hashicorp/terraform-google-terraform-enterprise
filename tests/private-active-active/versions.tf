terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.90"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.90"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.26"
    }
  }

  backend "remote" {
    organization = "terraform-enterprise-modules-test"

    workspaces {
      name = "google-private-active-active"
    }
  }
}
