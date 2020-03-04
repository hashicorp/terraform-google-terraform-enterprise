variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "subnetwork_ip_cidr_range" {
  default     = "10.1.0.0/16"
  description = "The range of IP addresses to provision in the subnetwork, expressed in CIDR notation."
  type        = string
}
