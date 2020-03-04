variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "region" {
  type        = string
  description = "The region to install into."
  default     = "us-central1-a"
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
