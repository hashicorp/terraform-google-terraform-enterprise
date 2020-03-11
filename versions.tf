terraform {
  # 0.12.17 is the earliest version of Terraform which supports trimsuffix.
  required_version = "~> 0.12.17"

  required_providers {
    # 3.1.0 is the earliest version of google which supports google_compute_firewall enable_logging
    google = "~> 3.1"
    # 3 is the latest major release
    google-beta = "~> 3.0"
    # 2.1.0 is the earliest version of random and template which is compatible with Terraform 0.12
    random   = "~> 2.1"
    template = "~> 2.1"
  }
}
