variable "labels" {
  default     = {}
  description = "The labels which will be applied to the storage bucket."
  type        = map(string)
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "service_account_email" {
  description = "The email address of the service account which will be used to access the storage bucket."
  type        = string
}
