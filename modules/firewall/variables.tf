variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "vpc_name" {
  type        = string
  description = "Name of Google Compute Network to install firewall to"
}

variable "subnet_ip_range" {
  type        = string
  description = "IP Range in CIDR syntax for the subnet to allow access to for health checks"
}

variable "healthcheck_ips" {
  type        = list(string)
  description = "List of gcp health check ips to allow through the firewall"
  default     = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
}

variable "firewall_ports" {
  type        = list(string)
  description = "Additional ports to allow through the firewall"
  default     = []
}

variable "prefix" {
  type        = string
  description = "Name to attach to your VPC"
  default     = "tfe-"
}
