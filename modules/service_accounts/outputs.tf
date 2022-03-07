output "credentials" {
  value = base64decode(google_service_account_key.key.private_key)

  description = "The private key of the service account."
}
output "service_account" {
  value = var.override_service_account_id == null ? google_service_account.main[0] : data.google_service_account.main[0]

  description = "The service account."
}
