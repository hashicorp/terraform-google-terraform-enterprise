terraform {
  required_version = ">= 1.1.3"

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
