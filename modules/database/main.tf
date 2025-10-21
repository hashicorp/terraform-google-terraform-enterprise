# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "postgres" {
  length = 2
}

resource "google_sql_database_instance" "tfe" {
  name             = "${var.namespace}-tfe-${random_pet.postgres.id}"
  database_version = var.postgres_version

  settings {
    tier              = var.machine_type
    availability_type = var.availability_type
    disk_size         = var.disk_size

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.service_networking_connection.network
    }

    backup_configuration {
      enabled    = var.backup_start_time == null ? false : true
      start_time = var.backup_start_time
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = var.enable_iam_authentication ? "on" : "off"
    }

    user_labels = var.labels
  }

  deletion_protection = false
}

resource "random_string" "postgres_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>?"
}

resource "google_sql_database" "tfe" {
  name     = var.dbname
  instance = google_sql_database_instance.tfe.name
}

resource "google_sql_user" "tfe" {
  name     = var.username
  instance = google_sql_database_instance.tfe.name

  deletion_policy = "ABANDON"
  password        = random_string.postgres_password.result
}

# IAM database user for passwordless authentication
resource "google_sql_user" "tfe_iam" {
  count = var.enable_iam_authentication ? 1 : 0

  # Cloud SQL has a 63 character limit for usernames. For IAM service accounts,
  # strip the .gserviceaccount.com suffix to create a shorter username
  name     = replace(var.iam_user_email, ".gserviceaccount.com", "")
  instance = google_sql_database_instance.tfe.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"

  deletion_policy = "ABANDON"
}
