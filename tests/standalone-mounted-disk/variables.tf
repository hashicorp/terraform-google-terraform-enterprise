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

variable "google_credentials" {
  default     = null
  description = "Credentials of the Google Cloud account which will host the test infrastructure."
  type        = string
}

variable "google_project" {
  default     = null
  description = "Project in the Google Cloud account which will host the test infrastructure."
  type        = string
}

variable "google_region" {
  default     = null
  description = "Region in the Google Cloud account which will host the test infrastructure."
  type        = string
}

variable "google_zone" {
  default     = null
  description = "Workspace of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
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