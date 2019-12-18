variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "subnet" {
  type        = string
  description = "GCP Subnetwork Name for Load Balancer"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "primaries" {
  type        = string
  description = "GCP Instance Group for the primaries"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

