output "bucket" {
  value = google_storage_bucket.main

  description = "The storage bucket in which critical application state will be stored."
}
