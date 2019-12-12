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

variable "primary_hostnames" {
  type        = list(string)
  description = "Hostnames of the primaries to load balance to"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

