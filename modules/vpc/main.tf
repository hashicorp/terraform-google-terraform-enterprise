resource "google_compute_network" "tfe_vpc" {
  name                    = "${var.prefix}vpc-${var.install_id}"
  description             = "Terraform Enterprise VPC Network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tfe_subnet" {
  name          = "${var.prefix}subnet-${var.install_id}"
  ip_cidr_range = var.subnet_range
  region        = var.region
  network       = google_compute_network.tfe_vpc.self_link
}
