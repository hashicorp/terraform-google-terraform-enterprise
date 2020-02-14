output "bucket" {
  value = google_service_account.primary

  description = "The service account which will be used to access the storage bucket."
}

output "credentials" {
  value = base64decode(google_service_account_key.tfe.private_key)
}

output "primary" {
  value = google_service_account.primary

  description = "The service account to be attached to the primary VM instance template."
}
