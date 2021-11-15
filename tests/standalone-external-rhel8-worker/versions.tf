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

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1"
    }
  }
}
