variable "labels" {
  default     = {}
  description = "A collection of labels which will be applied to resources."
  type        = map(string)
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "service_account_internal_load_balancer_email" {
  description = "The email address of the service account which is associated with internal load balancer."
  type        = string
}

variable "service_account_primaries_load_balancer_email" {
  description = "The email address of the service account which is associated with the primaries load balancer."
  type        = string
}

variable "service_account_primaries_email" {
  description = "The email address of the service account which is associated with the primaries."
  type        = string
}

variable "service_account_secondaries_email" {
  description = "The email address of the service account which is associated with the secondaries."
  type        = string
}

variable "service_project" {
  description = "The ID of the service project."
  type        = string
}
