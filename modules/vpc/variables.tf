variable "region" {
  description = "The region in which resources will be created."
  type        = string
}

variable "subnetwork_ip_cidr_range" {
  default     = "10.1.0.0/16"
  description = "The IP address range to be assigned to the subnetwork, expressed in CIDR notation."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}
