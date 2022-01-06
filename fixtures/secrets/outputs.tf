output "ca_certificate_secret" {
  value = local.ca_certificate_enabled ? google_secret_manager_secret.ca_certificate[0].secret_id : null

  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file for a Certificate Authority.
  EOD
}

output "ca_private_key_secret" {
  value = local.ca_private_key_enabled ? google_secret_manager_secret.ca_certificate[0].secret_id : null

  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM private key file for a Certificate Authority.
  EOD
}

output "license_secret" {
  value = local.license_enabled ? google_secret_manager_secret.license[0].secret_id : null

  description = "The Secret Manager secret which comprises the Base64 encoded Replicated license file."
}

output "ssl_certificate_secret" {
  value = local.ssl_certificate_enabled ? google_secret_manager_secret.ssl_certificate[0].secret_id : null

  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file for a Certificate Authority.
  EOD
}

output "ssl_private_key_secret" {
  value = local.ssl_private_key_enabled ? google_secret_manager_secret.ssl_private_key[0].secret_id : null

  description = "The Secret Manager secret which comprises the Base64 encoded PEM private key file."
}
