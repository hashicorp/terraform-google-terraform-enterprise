variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "labels" {
  description = "Labels which will be assigned to all applicable resources."
  type        = map(string)
}

variable "location" {
  description = "Location of the GCS bucket used as the object store."
  type        = string
  default     = "US"
}
