variable "load_balancer_address" {
  description = "The public IP address of the external load balancer."
  type        = string
}

variable "hostname" {
  default     = "tfe"
  description = "The hostname for the external load balancer."
  type        = string
}

variable "managed_zone" {
  description = "The name of the managed DNS zone in which the application will be accessible."
  type        = string
}

variable "managed_zone_dns_name" {
  description = "The fully qualified DNS name of the managed zone set by var.managed_zone."
  type        = string
}
