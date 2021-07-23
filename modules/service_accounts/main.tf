resource "random_pet" "name" {
  length = 2
}

resource "google_service_account" "main" {
  account_id   = "${var.namespace}-tfe-${random_pet.name.id}"
  display_name = "TFE"
  description  = "Service Account used by Terraform Enterprise."
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.main.name
}

locals {
  member = "serviceAccount:${google_service_account.main.email}"
}

resource "google_storage_bucket_iam_member" "member_object" {
  bucket = var.bucket
  role   = "roles/storage.objectAdmin"
  member = local.member
}

resource "google_storage_bucket_iam_member" "member_bucket" {
  bucket = var.bucket
  role   = "roles/storage.legacyBucketReader"
  member = local.member
}

resource "google_project_iam_member" "log_writer" {
  member = local.member
  role   = "roles/logging.logWriter"
}

resource "google_secret_manager_secret_iam_member" "license" {
  member    = local.member
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.license_secret
}
