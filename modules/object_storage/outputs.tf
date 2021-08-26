output "bucket" {
  value = google_storage_bucket.tfe.name

  description = "The name of the storage bucket."
}
output "project" {
  value = google_storage_bucket.tfe.project

  description = "The ID of the project in which the storage bucket resides."
}
output "location" {
  value = google_storage_bucket.tfe.location
  description = "The location of the object store bucket."
}