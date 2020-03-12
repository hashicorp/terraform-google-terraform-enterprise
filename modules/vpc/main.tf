resource "google_compute_network" "main" {
  name                    = "${var.prefix}-vpc"
  description             = "Terraform Enterprise VPC Network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "${var.prefix}-subnetwork"
  ip_cidr_range = var.subnetwork_ip_cidr_range
  network       = google_compute_network.main.self_link
}

resource "google_compute_router" "router" {
  name    = "${var.prefix}-router"
  network = google_compute_network.main.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.prefix}-router-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
