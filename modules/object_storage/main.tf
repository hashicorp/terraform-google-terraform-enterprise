resource "random_pet" "gcs" {
  length = 2
}

resource "google_storage_bucket" "tfe" {
  name     = "${var.namespace}-storage-${random_pet.gcs.id}"
  location = "us"

  force_destroy = true
  labels        = var.labels
}
