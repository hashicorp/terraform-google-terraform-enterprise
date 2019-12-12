variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "cert" {
  type        = string
  description = "certificate for the load balancer"
}

variable "instance_group" {
  type        = string
  description = "primary instance group"
}

variable "ssl_policy" {
  type        = string
  description = "SSL policy for the cert. Default to TLS 1.2 Only"
  default     = ""
}
