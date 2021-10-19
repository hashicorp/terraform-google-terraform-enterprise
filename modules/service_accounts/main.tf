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
  count = var.bucket == null ? 0 : 1

  bucket = var.bucket
  role   = "roles/storage.objectAdmin"
  member = local.member
}

resource "google_storage_bucket_iam_member" "member_bucket" {
  count = var.bucket == null ? 0 : 1

  bucket = var.bucket
  role   = "roles/storage.legacyBucketReader"
  member = local.member
}

resource "google_project_iam_member" "log_writer" {
  member = local.member
  role   = "roles/logging.logWriter"
}

resource "google_secret_manager_secret_iam_member" "license_secret" {
  member    = local.member
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.license_secret
}

resource "google_secret_manager_secret_iam_member" "ca_certificate_secret" {
  count = var.ca_certificate_secret == null ? 0 : 1

  member    = local.member
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.ca_certificate_secret
}

resource "google_secret_manager_secret_iam_member" "ssl_certificate_secret" {
  count = var.ssl_certificate_secret == null ? 0 : 1

  member    = local.member
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.ssl_certificate_secret
}

resource "google_secret_manager_secret_iam_member" "ssl_private_key_secret" {
  count = var.ssl_private_key_secret == null ? 0 : 1

  member    = local.member
  role      = "roles/secretmanager.secretAccessor"
  secret_id = var.ssl_private_key_secret
}
