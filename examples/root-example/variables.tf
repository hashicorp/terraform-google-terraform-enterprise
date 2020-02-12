
variable "credentials" {
  type        = string
  description = "Path to GCP credentials .json file"
}

variable "dnszone" {
  type        = string
  description = "Name of the managed dns zone to create records into"
}

variable "license_file" {
  type        = string
  description = "Replicated license file"
}

variable "project" {
  type        = string
  description = "Name of the project to deploy into"
}

variable "region" {
  type        = string
  description = "The region to install into."
  default     = "us-central1"
}