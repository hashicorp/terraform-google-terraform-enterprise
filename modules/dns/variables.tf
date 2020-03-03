variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "dnszone" {
  type        = string
  description = "name of the managed dns zone"
}

variable "hostname" {
  type        = string
  description = "DNS hostname for load balancer, appended with the zone's domain"
}

variable "address" {
  type        = string
  description = "IP Address to associate with the hostname"
}

variable "project" {
  type        = string
  description = "GCP Project to find the DNS Zone"
}
