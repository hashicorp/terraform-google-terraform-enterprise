variable "region" {
  default = "us-central1"
}

provider "google" {
  region      = "${var.region}"
}

provider "google-beta" {
  region      = "${var.region}"
}

module "tfe-beta" {
  source = "hashicorp/tfe-ha/google"
  version = "0.0.1"
  creds = "auth-file-123456678.json"
  region = "${var.region}"
  zone = "${var.region}-a"
  project = "tfe-beta"
  domain = "example.com"
  dnszone = "example"
  publicip = "1.2.3.4"
  cert = "https://www.googleapis.com/compute/v1/project/terraform-test/global/sslCertificates/tfe"
  sslpolicy = "tfe-ssl-policy"
  subnet = "tfe-subnet"
  frontenddns = "tfe-beta"

  primary_count = "1"
  worker_count  = "0"

  license_file = "customer.rli"
}