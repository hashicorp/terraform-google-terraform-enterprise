output "storage_key" {
  value = google_service_account_key.storage

  description = "The key which will be used to authenticate as the storage service account."
}
