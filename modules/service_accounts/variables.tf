variable "bucket" {
  description = "The self link of the storage bucket in which Terraform Enterprise stores data."
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "secrets" {
  description = <<-EOD
  A list of Secret Manager secrets which the service account will be authorized to access. The Terraform provider calls
  these values the secret_id and the GCP UI calls them the name.
  EOD
  type        = list(string)
}
