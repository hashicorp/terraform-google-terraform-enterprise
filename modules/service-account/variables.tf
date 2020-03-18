variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "bucket" {
  type        = string
  description = "GCS Bucket to give permissions on"
}
