variable "storage_bucket_name" {
  description = "The name of the storage bucket which will be used to hold application state information."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}
