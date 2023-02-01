# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "instance_image" {
  description = "The identifier of the image which will be used to initialize the boot disk."
  type        = string
}

variable "labels" {
  default     = {}
  description = "Labels to apply to resources."
  type        = map(string)
}

variable "mitmproxy_ca_certificate_secret" {
  default     = null
  description = <<-EOD
  The identifier of a secret comprising a Base64 encoded PEM certificate file for the mitmproxy Certificate Authority.
  For GCP, the Terraform provider calls this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "mitmproxy_ca_private_key_secret" {
  default     = null
  description = <<-EOD
  The identifier of a secret comprising a Base64 encoded PEM private key file for the mitmproxy Certificate Authority.
  For GCP, the Terraform provider calls this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "name" {
  description = "The name to be applied to resources."
  type        = string
}

variable "network" {
  description = "The Terraform Enterprise network."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  description = "The Terraform Enterprise subnetwork."
  type = object({
    ip_cidr_range = string
    self_link     = string
  })
}

variable "existing_service_account_id" {
  description = <<-EOD
  An ID of an existing service account to use for log management. Setting this value prevents terraform from creating
  a new user and assigning  a logWriter IAM role.
  EOD
  type        = string
  default     = null
}