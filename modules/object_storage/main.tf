resource "random_pet" "gcs" {
  length = 2
}

resource "google_storage_bucket" "tfe" {
  name     = "${var.namespace}-storage-${random_pet.gcs.id}"
  location = var.location

  force_destroy = true
  labels        = var.labels
}
