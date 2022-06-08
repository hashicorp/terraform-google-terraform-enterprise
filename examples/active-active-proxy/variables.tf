variable "ca_certificate_secret_id" {
  type        = string
  description = "The secrets manager secret name of the Base64 encoded CA certificate for mitm"
}

variable "ca_private_key_secret_id" {
  type        = string
  description = "The secrets manager secret name of the Base64 encoded CA private key for mitm"
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
}

variable "google" {
  description = "Attributes of the Google Cloud account which will host the test infrastructure."
  type = object({
    credentials     = string
    project         = string
    region          = string
    zone            = string
    service_account = string
  })
}

variable "node_count" {
  description = "The number of compute instances to create."
  type        = number
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license."
}

variable "ssl_certificate_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file. The Terraform provider calls this
  value the secret_id and the GCP UI calls it the name. This value is only used when load_balancer == "PRIVATE_TCP".
  EOD
  type        = string
}

variable "ssl_private_key_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM private key file. The Terraform provider calls this
  value the secret_id and the GCP UI calls it the name. This value is only used when load_balancer == "PRIVATE_TCP".
  EOD
  type        = string
}