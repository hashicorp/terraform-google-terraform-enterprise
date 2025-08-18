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
  cluster_id = random_pet.alloydb.id
  database_version = "POSTGRES_16"
  location   = "us-central1"
  network_config {
    network = google_compute_network.default.id
  }

  initial_user {
    password = random_string.alloydb_password.result
  }
}

data "google_project" "project" {}

resource "google_compute_network" "default" {
  name = "alloydb-network"
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          =  "alloydb-cluster"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

resource "random_string" "alloydb_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>?"
}

resource "google_alloydb_user" "tfe" {
  cluster = google_alloydb_cluster.default.name
  user_id = "user1"
  user_type = "ALLOYDB_BUILT_IN"

  password = "user_secret"
  database_roles = ["alloydbsuperuser"]
  depends_on = [google_alloydb_instance.default]
}