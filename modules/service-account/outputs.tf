output "credentials" {
  value = base64decode(google_service_account_key.tfe.private_key)
}
