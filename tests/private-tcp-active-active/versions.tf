terraform {
  required_version = ">= 1.1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.54"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "remote" {
    organization = "terraform-enterprise-modules-test"

    workspaces {
      name = "google-private-tcp-active-active"
    }
  }
}
