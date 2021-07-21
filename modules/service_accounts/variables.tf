variable "bucket" {
  description = "The self link of the storage bucket in which the Terraform Enterprise deployment stores data."
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}
