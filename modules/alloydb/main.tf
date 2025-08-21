# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "alloydb" {
  length = 2
}

resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "${var.namespace}-tfe-${random_pet.alloydb.id}-1"
  instance_type = "PRIMARY"
  availability_type = "ZONAL"

  machine_config {
    cpu_count = 2
  }
}

resource "google_alloydb_cluster" "default" {
  cluster_id       = "${var.namespace}-tfe-${random_pet.alloydb.id}"

  database_version = var.postgres_version
  location         = "us-east4"
  network_config {
    network = var.network.id
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