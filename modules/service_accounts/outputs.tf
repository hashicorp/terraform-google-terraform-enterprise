output "credentials" {
  value = base64decode(google_service_account_key.key.private_key)

  description = "The private key of the service account."
}
output "email" {
  value = google_service_account.main.email

  description = "The email address of the service account."
}
