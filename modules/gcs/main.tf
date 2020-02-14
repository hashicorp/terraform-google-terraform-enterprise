locals {
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_storage_bucket" "main" {
  name     = "${var.prefix}storage-${var.install_id}"
  location = "us"
  labels   = var.labels
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = google_storage_bucket.main.name
  member = local.member
  role   = "roles/storage.objectAdmin"
}

resource "google_storage_bucket_iam_member" "legacy_bucket_reader" {
  bucket = google_storage_bucket.main.name
  member = local.member
  role   = "roles/storage.legacyBucketReader"
}
