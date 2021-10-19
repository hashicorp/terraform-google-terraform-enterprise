variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "labels" {
  description = "Labels which will be assigned to all applicable resources."
  type        = map(string)
}

variable "service_account" {
  description = "The service account associated with the compute instances that host Terraform Enterprise."
  type = object({
    email = string
  })
}
