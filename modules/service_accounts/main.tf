resource "random_id" "account" {
  # 30 bytes ensures that enough characters are generated to satisfy the service account ID requirements, regardless of
  # the prefix.
  byte_length = 30
  prefix      = "${var.namespace}-tfe-"
}

resource "google_service_account" "main" {
  # Limit the string used to 30 characters.
  account_id   = substr(random_id.account.dec, 0, 30)
  display_name = "TFE"
  description  = "Service Account used by Terraform Enterprise."
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.main.name
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

resource "google_secret_manager_secret_iam_member" "secrets" {
  for_each = toset(compact(var.secrets))

  member    = local.member
  role      = "roles/secretmanager.secretAccessor"
  secret_id = each.value
}
