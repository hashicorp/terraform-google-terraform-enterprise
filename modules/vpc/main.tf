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

resource "google_compute_router" "router" {
  name    = "${var.prefix}router-${var.install_id}"
  region  = var.region
  network = google_compute_network.tfe_vpc.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.prefix}router-nat-${var.install_id}"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

