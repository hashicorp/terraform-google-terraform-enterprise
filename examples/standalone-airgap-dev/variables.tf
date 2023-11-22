# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
variable "gcp_project_id" {
  description = "GCP Project ID to deploy resources into."
  type        = string
}

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
  description = "The ID of the logging service account to use for compute resources deployed."
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
