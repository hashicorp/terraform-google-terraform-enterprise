variable "existing_service_account_id" {
  type        = string
  description = "The id of the logging service account to use for compute resources deployed."
}

variable "license_file" {
  default     = null
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "tfe" {
  description = "Attributes of the Terraform Enterprise instance which manages the base infrastructure."
  type = object({
    hostname     = string
    organization = string
    token        = string
    workspace    = string
  })
}

variable "tfe_license_secret_id" {
  default     = null
  type        = string
  description = "The Secrets Manager secret ARN under which the Base64 encoded Terraform Enterprise license is stored."
}