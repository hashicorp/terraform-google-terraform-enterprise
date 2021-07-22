variable "project" {
  description = "The GCP project in which resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region in which resources will be created."
  type        = string
}

variable "credentials_file" {
  description = <<-EOD
  The pathname of the service account key file that will be used to authenticate the google provider against GCP.
  EOD
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "tfe_license_name" {
  description = <<-EOD
  The name that will be assigned to the Replicated license file when it is uploaded to the storage bucket.
  EOD
  type        = string
}
variable "tfe_license_path" {
  description = <<-EOD
  The pathname of the Replicated license file that will be used to authorize the Terraform Enterprise installation.
  EOD
  type        = string
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "ssl_certificate_name" {
  description = <<-EOD
  The name of an existing SSL certificate which will be used to authenticate connections to the load balancer.
  EOD
  type        = string
}
