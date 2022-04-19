variable "airgap_url" {
  description = "The URL of the storage object that comprises an airgap package."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license."
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "ssl_certificate_name" {
  description = <<-EOD
  The name of an existing SSL certificate which will be used to authenticate connections to the load balancer.
  EOD
  type        = string
}
