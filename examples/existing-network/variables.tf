# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
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

variable "node_count" {
  description = "The number of compute instances to create."
  type        = number
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license."
}

variable "network" {
  description = "The self link of the network to which Terraform Enterprise will be attached."
  type        = string
}

variable "subnetwork" {
  description = "The self link of the subnetwork to which Terraform Enterprise will be attached."
  type        = string
}

variable "ssl_certificate_name" {
  description = <<-EOD
  The name of an existing SSL certificate which will be used to authenticate connections to the load balancer.
  EOD
  type        = string
}
