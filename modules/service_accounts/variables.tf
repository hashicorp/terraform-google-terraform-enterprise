variable "bucket" {
  description = "The self link of the storage bucket in which Terraform Enterprise stores data."
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}
