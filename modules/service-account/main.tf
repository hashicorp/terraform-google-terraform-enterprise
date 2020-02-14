resource "google_service_account" "storage" {
  account_id = "${var.prefix}storage"

  description  = "The identity which will be used to access the TFE storage bucket."
  display_name = "TFE Storage"
}

resource "google_service_account_key" "storage" {
  service_account_id = google_service_account.storage.name
}

resource "google_service_account" "primary_cluster" {
  account_id = "${var.prefix}primaries"

  display_name = "TFE Primary Cluster"
  description  = "The identity to be associated with the TFE primary compute instances."
}

resource "google_service_account" "secondary_cluster" {
  account_id = "${var.prefix}secondaries"

  display_name = "TFE Secondary Cluster"
  description  = "The identity to be associated with the TFE secondary compute instances."
}
