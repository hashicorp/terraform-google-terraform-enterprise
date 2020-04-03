output "primaries" {
  value = google_service_account.primaries

  description = "The service account to be associated with the primaries."
}

output "internal_load_balancer" {
  value = google_service_account.internal_load_balancer

  description = "The service account to be associated with the internal load balancer."
}

output "secondaries" {
  value = google_service_account.secondaries

  description = "The service account to be associated with the secondaries."
}

output "storage" {
  value = google_service_account.storage

  description = "The service account which will be used to access the storage bucket."
}

output "storage_key" {
  value = google_service_account_key.storage

  description = "The key which will be used to authenticate as the storage service account."
}
