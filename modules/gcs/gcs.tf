resource "google_storage_bucket" "tfe-bucket" {
  name     = "${var.prefix}storage-${var.install_id}"
  location = "us"
  labels   = var.labels
}

