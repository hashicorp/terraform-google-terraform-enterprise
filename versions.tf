terraform {
  # 0.12.17 is the earliest version of Terraform which supports trimsuffix.
  required_version = "~> 0.12.17"

  required_providers {
    # 3.2.0 is the earliest version of google which supports google_compute_url_map path_rule
    google = "~> 3.2"
    # google-beta is synchronized with google
    google-beta = "~> 3.2"
    # 2.1.0 is the earliest version of random and template which is compatible with Terraform 0.12
    random   = "~> 2.1"
    template = "~> 2.1"
  }
}
