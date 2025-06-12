# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "google_compute_image" "rhel" {
  name    = "rhel-7-v20220519"
  project = "rhel-cloud"
}

data "google_compute_image" "ubuntu" {
  name    = "ubuntu-2404-noble-amd64-v20250606"
  project = "ubuntu-os-cloud"
}
