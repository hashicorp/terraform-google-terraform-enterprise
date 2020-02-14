resource "google_service_account" "bucket" {
  account_id = "${var.prefix}bucket-${var.install_id}"

  project = var.project

  description  = "The identity which manges the TFE storage bucket."
  display_name = "TFE Bucket"
}

resource "google_service_account_key" "bucket" {
  service_account_id = google_service_account.bucket.name
}

resource "google_service_account" "primary" {
  account_id = "${var.prefix}primary-${var.install_id}"

  project = var.project

  display_name = "TFE Primary"
  description  = "The identity of the TFE primary compute instances."
}
