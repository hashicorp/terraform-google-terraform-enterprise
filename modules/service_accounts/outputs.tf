output "credentials" {
  value = base64decode(google_service_account_key.key.private_key)

  description = "The private key of the service account."
}
output "service_account" {
  value = google_service_account.main

  description = "The service account."
}
