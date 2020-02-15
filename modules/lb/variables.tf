variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "project" {
  type = string
  description = "The project in which resources will be created."
}

variable "cert" {
  type        = string
  description = "certificate for the load balancer"
}

variable "primary_group" {
  type        = string
  description = "The ID of the primary compute instance group or the primary network endpoint group."
}

variable "secondary_group" {
  type        = string
  description = "The ID of the secondary compute instance group or the secondary network endpoint group."
}

variable "ssl_policy" {
  type        = string
  description = "SSL policy for the cert. Default to TLS 1.2 Only"
  default     = ""
}
