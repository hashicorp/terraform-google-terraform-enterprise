# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "consolidated_services_enabled" {
  default     = true
  type        = bool
  description = "(Required) True if TFE uses consolidated services."
}

variable "existing_service_account_id" {
  default     = null
  type        = string
  description = "The id of the logging service account to use for compute resources deployed."
}

variable "license_file" {
  default     = null
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "tfe_hostname" {
  default     = null
  description = "Hostname of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe_organization" {
  default     = null
  description = "Organization of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe_token" {
  default     = null
  description = "Token of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe_workspace" {
  default     = null
  description = "Workspace of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe" {
  default     = null
  description = "Attributes of the Terraform Enterprise instance which manages the base infrastructure."
  type = object({
    hostname     = string
    organization = string
    token        = string
    workspace    = string
  })
}
