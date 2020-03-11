output "bucket" {
  value = google_storage_bucket.main

  description = "The storage bucket in which application data will be stored."
}
