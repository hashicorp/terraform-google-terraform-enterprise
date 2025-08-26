# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "alloydb" {
  length = 2
}

resource "google_alloydb_instance" "tfe" {
  cluster           = google_alloydb_cluster.tfe.name
  instance_id       = "${var.namespace}-tfe-${random_pet.alloydb.id}-1"
  instance_type     = "PRIMARY"
  availability_type = var.availability_type
  labels            = var.labels

  machine_config {
    cpu_count = 2
  }
  # You get a NETWORK_PEERING_DELETED error if you don't wait for the service networking connection to be created.
  depends_on = [var.service_networking_connection]
}

resource "google_alloydb_cluster" "tfe" {
  cluster_id = "${var.namespace}-tfe-${random_pet.alloydb.id}"

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
  cluster   = google_alloydb_cluster.tfe.name
  user_id   = var.username
  user_type = "ALLOYDB_BUILT_IN"

  password       = random_string.alloydb_password.result
  database_roles = ["alloydbsuperuser"]
  depends_on     = [google_alloydb_instance.tfe]
}