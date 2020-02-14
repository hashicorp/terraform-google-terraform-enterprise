output "credentials" {
  value = base64decode(google_service_account_key.tfe.private_key)
}

output "primary" {
  value = google_service_account.primary

  description = "The service account to be applied to the primary VM instance template."
}
