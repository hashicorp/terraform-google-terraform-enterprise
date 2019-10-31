variable "region" {
  default = "us-central1"
}

variable "project" {}

provider "google" {
  region  = "${var.region}"
  project = "${var.project}"
}

provider "google-beta" {
  region  = "${var.region}"
  project = "${var.project}"
}

module "tfe-cluster" {
  source           = "hashicorp/terraform-enterprise/google"
  version          = "0.1.0"
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
  secondary_count = "2"

  license_file = "customer.rli"

  image_family = "rhel-7-v20190729"

  gcs_bucket          = "tfe-bucket"
  postgresql_address  = "192.168.100.100"
  postgresql_database = "tfe-cluster-db"
  postgresql_user     = "postgres"
  postgresql_password = "RdJeirkEZGdvCg=="
}

output "tfe-cluster" {
  value = {
    application_endpoint         = "${module.tfe-cluster.application_endpoint}"
    application_health_check     = "${module.tfe-cluster.application_health_check}"
    installer_dashboard_password = "${module.tfe-cluster.installer_dashboard_password}"
    installer_dashboard__url     = "${module.tfe-cluster.installer_dashboard_url}"
    primary_public_ip            = "${module.tfe-cluster.primary_public_ip}"
  }
}
