locals {
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_storage_bucket" "main" {
  name = "${var.prefix}storage"

  bucket_policy_only = true
  labels             = var.labels
  location           = var.location
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
