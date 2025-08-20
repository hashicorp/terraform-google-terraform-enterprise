# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "alloydb" {
  length = 2
}

resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "alloydb-instance"
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = 2
  }

  depends_on = [google_service_networking_connection.vpc_connection]
}

resource "google_alloydb_cluster" "default" {
  cluster_id       = "${var.namespace}-tfe-${random_pet.alloydb.id}"

  database_version = var.postgres_version
  location         = "us-central1"
  network_config {
    network = var.service_networking_connection.network
  }
  initial_user {
    password = random_string.alloydb_password.result
  }
}

resource "random_string" "alloydb_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>?"
}

resource "google_alloydb_user" "tfe" {
  cluster   = google_alloydb_cluster.default.name
  user_id   = var.username
  user_type = "ALLOYDB_BUILT_IN"

  password       = "user_secret"
  database_roles = ["alloydbsuperuser"]
  depends_on     = [google_alloydb_instance.default]
}