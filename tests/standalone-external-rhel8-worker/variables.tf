variable "existing_service_account_id" {
  type        = string
  description = "The id of the logging service account to use for compute resources deployed."
}

variable "license_file" {
  default     = null
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}


variable "google_credentials" {
  description = "Credentials of the Google Cloud account which will host the test infrastructure."
  type        = string
}

variable "google_project" {
  description = "Project in the Google Cloud account which will host the test infrastructure."
  type        = string
}

variable "google_region" {
  description = "Region in the Google Cloud account which will host the test infrastructure."
  type        = string
}

variable "google_service_account" {
  description = "Workspace of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "google_zone" {
  description = "Workspace of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe_hostname" {
  description = "Hostname of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe_license_secret_id" {
  default     = null
  type        = string
  description = "The Secrets Manager secret ARN under which the Base64 encoded Terraform Enterprise license is stored."
}

variable "tfe_organization" {
  description = "Organization of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe_token" {
  description = "Token of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe_workspace" {
  description = "Workspace of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}