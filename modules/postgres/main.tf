resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "${var.prefix}-private-ip-address"
  purpose       = "VPC_PEERING"
  address       = "10.200.1.0"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.network_name
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network = var.network_name
  service = "servicenetworking.googleapis.com"

  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "tfe" {
  provider         = google-beta
  name             = "${var.prefix}-tfe"
  database_version = "POSTGRES_9_6"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.instance.tier
    availability_type = var.instance.availability_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_name
    }

    backup_configuration {
      enabled    = var.instance.backup_start_time == "" ? false : true
      start_time = var.instance.backup_start_time
    }

    user_labels = var.instance.labels
  }
}

resource "random_string" "default_password" {
  length  = 20
  special = false
}

locals {
  password = var.database.user_password != "" ? var.database.user_password : random_string.default_password.result
}

resource "google_sql_database" "tfe" {
  name     = var.database.name
  instance = google_sql_database_instance.tfe.name
}

resource "google_sql_user" "tfe" {
  name     = var.database.user_name
  instance = google_sql_database_instance.tfe.name

  password = local.password
}
