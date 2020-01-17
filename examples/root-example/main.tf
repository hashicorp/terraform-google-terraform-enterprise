provider "google" {
  version = "~> 3.0"

  region  = "${var.region}"
  project = "${var.project}"
}

provider "google-beta" {
  version = "~> 3.0"

  region  = "${var.region}"
  project = "${var.project}"
}

provider "random" {
  version = "~> 2.2"
}

provider "template" {
  version = "~> 2.1"
}

module "tfe-cluster" {
  source           = "hashicorp/terraform-enterprise/google"
  version          = "0.1.1"
  credentials_file = "auth-file-123456678.json"
  region           = "${var.region}"
  zone             = "${var.region}-a"
  project          = "${var.project}"
  domain           = "example.com"
  dns_zone         = "example"
  public_ip        = "1.2.3.4"
  certificate      = "https://www.googleapis.com/compute/v1/project/terraform-test/global/sslCertificates/tfe"
  ssl_policy       = "tfe-ssl-policy"
  subnet           = "tfe-subnet"
  frontend_dns     = "tfe-cluster"

  primary_count   = "3"
  min_secondaries = "2"
  max_secondaries = "5"

  license_file = "customer.rli"
}
