# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">= 1.6"

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
}
