# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "dns_create_record" {
  description = "A toggle to control the creation of a DNS record for the load balancer IP address."
  type        = bool
}

variable "existing_service_account_id" {
  default     = null
  type        = string
  description = "The ID of the logging service account to use for compute resources deployed."
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
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
