variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "labels" {
  description = "Labels which will be assigned to all applicable resources."
  type        = map(string)
}

variable "location" {
  description = "Location of the GCS bucket"
  type        = string
  default     = "US"
}

variable "license_name" {
  description = <<-EOD
  The name that will be assigned to the Replicated license file when it is uploaded to the storage bucket.
  EOD
  type        = string
}

variable "license_path" {
  description = <<-EOD
  The pathname of the Replicated license file that will be used to authorize the Terraform Enterprise installation.
  EOD
  type        = string
}
