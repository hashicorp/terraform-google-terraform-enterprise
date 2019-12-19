resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "${var.prefix}private-ip-address-${var.install_id}"
  purpose       = "VPC_PEERING"
  address       = "10.200.1.0"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.network_url
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network = var.network_url
  service = "servicenetworking.googleapis.com"

  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "tfe" {
  provider         = google-beta
  name             = "${var.prefix}tfe-${var.install_id}"
  database_version = "POSTGRES_9_6"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier              = var.postgresql_machinetype
    availability_type = var.postgresql_availability_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_url
    }

    backup_configuration {
      enabled    = var.postgresql_backup_start_time == "" ? false : true
      start_time = var.postgresql_backup_start_time
    }

    user_labels = var.labels
  }
}

resource "random_string" "default_password" {
  length  = 20
  special = false
}

locals {
  password = var.postgresql_password != "" ? var.postgresql_password : random_string.default_password.result
}

resource "google_sql_database" "tfe" {
  name     = var.postgresql_dbname
  instance = google_sql_database_instance.tfe.name
}

resource "google_sql_user" "tfe" {
  name     = var.postgresql_user
  instance = google_sql_database_instance.tfe.name

  password = local.password
}
