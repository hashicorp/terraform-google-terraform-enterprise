variable "health_check_ip_cidr_ranges" {
  default     = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
  description = "The list of GCP health check IP address ranges from which health check traffic will be authorized to flow, expressed in CIDR notation. The default ranges were obtained from the GCP Health Checks Overview: https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges."
  type        = list(string)
}

variable "vpc_network_self_link" {
  description = "The self link of the network to which resources will be attached."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "ports" {
  default     = []
  description = "A list of additional ports over which traffic will be authorized to flow."
  type        = list(string)
}

variable "vpc_subnetwork_ip_cidr_range" {
  description = "The range of IP addresses in the subnetwork from which traffic will be authorized to flow, expressed in CIDR notation."
  type        = string
}
