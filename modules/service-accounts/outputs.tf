output "storage_bucket" {
  value = google_service_account.storage_bucket

  description = "The service account which will be used to access the storage bucket."
}

output "storage_bucket_key" {
  value = google_service_account_key.storage_bucket

  description = "The key of the storage bucket service account."
}

output "primary" {
  value = google_service_account.primary

  description = "The service account to be attached to the primary VM instance template."
}

output "proxy" {
  value = google_service_account.proxy

  description = "The service account to be attached to the proxy VM instance template."
}

output "secondary" {
  value = google_service_account.secondary

  description = "The service account to be attached to the secondary VM instance template."
}
