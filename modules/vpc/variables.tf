variable "health_check_address_ranges" {
  type        = list(string)
  description = "The list of GCP health check IP address ranges from which health check traffic will be authorized to flow, expressed in CIDR notation."
  default     = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "subnetwork_ip_cidr_range" {
  default     = "10.1.0.0/16"
  description = "The range of IP addresses to provision in the subnetwork, expressed in CIDR notation."
  type        = string
}
