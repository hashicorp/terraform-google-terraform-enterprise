variable "ca_certificate_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file for a Certificate Authority. The
  Terraform provider calls this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "license_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded Replicated license file. The Terraform provider calls
  this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "ssl_certificate_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file. The Terraform provider calls this
  value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "ssl_private_key_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM private key file. The Terraform provider calls this
  value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}
