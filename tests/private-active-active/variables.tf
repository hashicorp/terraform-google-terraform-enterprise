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

variable "google_zone" {
  description = "Workspace of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
}

variable "tfe_hostname" {
  description = "Hostname of the Terraform Enterprise instance which manages the base infrastructure."
  type        = string
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