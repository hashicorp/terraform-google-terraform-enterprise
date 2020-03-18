resource "google_storage_bucket" "main" {
  name     = "${var.prefix}storage"

  labels   = var.labels
  location = var.location
}
