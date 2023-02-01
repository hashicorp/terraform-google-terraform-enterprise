# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "gcs" {
  length = 2
}

resource "google_storage_bucket" "tfe" {
  name                        = "${var.namespace}-storage-${random_pet.gcs.id}"
  location                    = "us"
  uniform_bucket_level_access = true
  force_destroy               = true
  labels                      = var.labels
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = google_storage_bucket.tfe.name
  member = local.member
  role   = "roles/storage.objectAdmin"
}

resource "google_storage_bucket_iam_member" "legacy_bucket_reader" {
  bucket = google_storage_bucket.tfe.name
  member = local.member
  role   = "roles/storage.legacyBucketReader"
}
