output "ca_certificate_secret" {
  value = length(google_secret_manager_secret_version.ca_certificate) > 0 ? (
    google_secret_manager_secret_version.ca_certificate[0].secret
  ) : null

  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file for a Certificate Authority.
  EOD
}

output "ca_private_key_secret" {
  value = length(google_secret_manager_secret_version.ca_certificate) > 0 ? (
    google_secret_manager_secret_version.ca_certificate[0].secret
  ) : null

  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM private key file for a Certificate Authority.
  EOD
}

output "license_secret" {
  value = length(google_secret_manager_secret_version.license) > 0 ? (
    google_secret_manager_secret_version.license[0].secret
  ) : null

  description = "The Secret Manager secret which comprises the Base64 encoded Replicated license file."
}

output "ssl_certificate_secret" {
  value = length(google_secret_manager_secret_version.ssl_certificate) > 0 ? (
    google_secret_manager_secret_version.ssl_certificate[0].secret
  ) : null

  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file for a Certificate Authority.
  EOD
}

output "ssl_private_key_secret" {
  value = length(google_secret_manager_secret_version.ssl_private_key) > 0 ? (
    google_secret_manager_secret_version.ssl_private_key[0].secret
  ) : null

  description = "The Secret Manager secret which comprises the Base64 encoded PEM private key file."
}
