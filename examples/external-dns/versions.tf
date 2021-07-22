terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.54"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }
  }
}
