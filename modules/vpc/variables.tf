variable "healthchk_ips" {
  type        = list(string)
  description = "List of gcp health check ips to allow through the firewall"
  default     = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
}

variable "subnet_range" {
  type        = string
  description = "CIDR range for subnet"
  default     = "10.1.0.0/16"
}

variable "prefix" {
  type        = string
  description = "Name to attach to your VPC"
  default     = "tfe-"
}
