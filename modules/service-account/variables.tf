variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "bucket" {
  type        = string
  description = "GCS Bucket to give permissions on"
}

variable "project" {
  type        = string
  description = "The ID of the project in which the resources will be created."
}