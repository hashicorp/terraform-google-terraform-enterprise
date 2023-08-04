# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">= 0.14"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}
