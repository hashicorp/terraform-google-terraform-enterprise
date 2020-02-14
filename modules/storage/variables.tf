variable "labels" {
  default     = {}
  description = "A collection of labels which will be applied to the storage bucket."
  type        = map(string)
}

variable "location" {
  default     = null
  description = "The name of the storage location in which the bucket will be created."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "service_account_email" {
  type        = string
  description = "The email address of the service account which will be authorized to access the storage bucket."
}
