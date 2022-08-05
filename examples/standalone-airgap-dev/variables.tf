variable "airgap_url" {
  description = "The URL of the storage bucket object that comprises an airgap package."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "existing_service_account_id" {
  default     = null
  type        = string
  description = "The id of the logging service account to use for compute resources deployed."
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "ssl_certificate_name" {
  description = <<-EOD
  The name of an existing SSL certificate which will be used to authenticate connections to the load balancer.
  EOD
  type        = string
}




