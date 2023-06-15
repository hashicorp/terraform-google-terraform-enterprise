# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">= 0.14"
  backend "remote" {
    organization = "terraform-enterprise-modules-test"

    workspaces {
      name = "google-private-tcp-active-active"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
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
}
