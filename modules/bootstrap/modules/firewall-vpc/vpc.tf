resource "google_compute_network" "tfe_vpc" {
  name                    = "${var.name}-vpc"
  description             = "tfe VPC Network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tfe_subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = "${var.subnet_range}"
  region        = "${var.region}"
  network       = "${google_compute_network.tfe_vpc.self_link}"
}
