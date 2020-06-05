resource "google_service_networking_connection" "main" {
  network                 = var.vpc_network_self_link
  reserved_peering_ranges = [var.vpc_address_name]
  service                 = "servicenetworking.googleapis.com"
}

resource "random_pet" "name" {
  length = 1
  prefix = "${var.prefix}database"
}

resource "google_sql_database_instance" "main" {
  name             = random_pet.name.id
  database_version = "POSTGRES_9_6"
  settings {
    tier = var.machine_type

    availability_type = var.availability_type
    backup_configuration {
      enabled    = var.backup_start_time == null ? false : true
      start_time = var.backup_start_time
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_service_networking_connection.main.network
    }
    user_labels = var.labels
  }
}

resource "random_string" "default_password" {
  length  = 20
  special = false
}

locals {
  password = var.password != null ? var.password : random_string.default_password.result
}

resource "google_sql_database" "main" {
  instance = google_sql_database_instance.main.name
  name     = var.name
}

resource "google_sql_user" "main" {
  instance = google_sql_database_instance.main.name
  name     = var.username

  password = local.password
}
