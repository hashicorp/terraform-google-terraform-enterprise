resource "google_service_account" "storage_bucket" {
  account_id = "${var.prefix}storage-bucket-${var.install_id}"

  description  = "The identity which manges the TFE storage bucket."
  display_name = "TFE Storage Bucket"
}

resource "google_service_account_key" "storage_bucket" {
  service_account_id = google_service_account.storage_bucket.name
}

resource "google_service_account" "primary" {
  account_id = "${var.prefix}primary-${var.install_id}"

  display_name = "TFE Primary"
  description  = "The identity of the TFE primary compute instances."
}

resource "google_service_account" "secondary" {
  account_id = "${var.prefix}secondary-${var.install_id}"

  display_name = "TFE Secondary"
  description  = "The identity of the TFE secondary compute instances."
}

resource "google_service_account" "proxy" {
  account_id = "${var.prefix}proxy-${var.install_id}"

  display_name = "TFE Proxy"
  description  = "The identity of the TFE proxy compute instances."
}
