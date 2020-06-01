terraform {
  # 0.12.17 is the earliest version of Terraform which supports trimsuffix.
  required_version = "~> 0.12.17"

  required_providers {
    # 3.21.0 is the earliest version of google which supports:
    # * google_compute_region_target_https_proxy
    # * google_compute_region_url_map
    google = "~> 3.21"
    # google-beta is synchronized with google
    google-beta = "~> 3.21"
    # 2.1.0 is the earliest version of random and template which is compatible with Terraform 0.12
    random   = "~> 2.1"
    template = "~> 2.1"
  }
}
