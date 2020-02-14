resource "google_service_account" "tfe" {
  account_id = "${var.prefix}storage-${var.install_id}"

  project = var.project

  display_name = "TFE Service Account to access GCS"
}

resource "google_service_account_key" "tfe" {
  service_account_id = google_service_account.tfe.name
}

resource "google_service_account" "primary" {
  account_id = "${var.prefix}primary-${var.install_id}"

  project = var.project

  display_name = "TFE Primary"
  description  = "The identity to be attached to the TFE primary compute instances."
}
