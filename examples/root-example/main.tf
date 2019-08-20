variable "region" {
  default = "us-central1"
}

provider "google" {
  region = "${var.region}"
}

provider "google-beta" {
  region = "${var.region}"
}

module "tfe-beta" {
  source           = "hashicorp/tfe-ha/google"
  version          = "0.0.1-beta"
  credentials_file = "auth-file-123456678.json"
  region           = "${var.region}"
  zone             = "${var.region}-a"
  project          = "tfe-beta"
  domain           = "example.com"
  dns_zone         = "example"
  public_ip        = "1.2.3.4"
  certificate      = "https://www.googleapis.com/compute/v1/project/terraform-test/global/sslCertificates/tfe"
  ssl_policy       = "tfe-ssl-policy"
  subnet           = "tfe-subnet"
  frontend_dns     = "tfe-beta"

  primary_count   = "1"
  secondary_count = "0"

  license_file = "customer.rli"
}
