resource "google_service_account" "tfe" {
  account_id   = "${var.prefix}storage-${var.install_id}"
  display_name = "TFE Service Account to access GCS"
}

resource "google_service_account_key" "tfe" {
  service_account_id = google_service_account.tfe.name
}

data "google_iam_policy" "tfe" {
  binding {
    role = "roles/storage.objectAdmin"

    members = [
      "serviceAccount:${google_service_account.tfe.email}",
    ]
  }
}
