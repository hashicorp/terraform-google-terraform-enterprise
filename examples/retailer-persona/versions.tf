terraform {
  required_version = ">= 0.14"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }
  }
}
