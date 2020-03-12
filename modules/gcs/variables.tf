variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the storage bucket"
  default     = {}
}
