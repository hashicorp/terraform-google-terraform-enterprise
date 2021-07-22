terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.54"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.54"
    }
  }
}
