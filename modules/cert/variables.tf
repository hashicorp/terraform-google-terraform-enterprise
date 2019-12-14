variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "domain_name" {
  type        = string
  description = "The fully qualified domain name of to create the cert for"
}
