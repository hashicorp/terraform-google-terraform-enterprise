resource "google_service_account" "storage" {
  account_id = "${var.prefix}storage"

  description  = "The identity which will be used to access the TFE storage bucket."
  display_name = "TFE Storage"
}

resource "google_service_account_key" "storage" {
  service_account_id = google_service_account.storage.name
}

resource "google_storage_bucket_iam_member" "member-object" {
  bucket = var.storage_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.storage.email}"
}

resource "google_storage_bucket_iam_member" "member-bucket" {
  bucket = var.storage_bucket_name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${google_service_account.storage.email}"
}
