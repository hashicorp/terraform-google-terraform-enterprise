variable "cloud_dns_domain" {
  description = "The domain of the Cloud DNS zone in which a record will be created."
  type        = string
}

variable "cloud_dns_name" {
  description = "The name of the Cloud DNS zone in which a record will be created."
  type        = string
}

variable "license_secret_id" {
  description = "The identity of the Secret Manager secret which comprises the Base64 encoded Replicated license file."
  type        = string
}

variable "ssl_certificate_secret_id" {
  description = <<-EOD
  The identity of the Secret Manager secret which comprises the Base64 encoded PEM certificate for Terraform Enterprise.
  EOD
  type        = string
}

variable "ssl_private_key_secret_id" {
  description = <<-EOD
  The identity of the Secret Manager secret which comprises the Base64 encoded PEM private key for Terraform Enterprise.
  EOD
  type        = string
}
