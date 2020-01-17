variable "project" {
  type        = "string"
  description = "Name of the project to deploy into"
}

variable "region" {
  type        = "string"
  description = "The region to install into."
  default     = "us-central1"
}
