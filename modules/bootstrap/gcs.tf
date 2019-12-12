resource "google_storage_bucket" "tfe-bucket" {
  name     = "${var.name}-storage-bucket-${random_id.db_name_suffix.hex}"
  location = "us"
}

