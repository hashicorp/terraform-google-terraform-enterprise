variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "subnet" {
  type        = object({ ip_cidr_range = string, network = string, self_link = string })
  description = "GCP Subnetwork for Load Balancer"
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
