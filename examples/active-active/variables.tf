variable "node_count" {
  description = "The number of compute instances to create."
  type        = number
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "tfe_license_name" {
  description = <<-EOD
  The name that will be assigned to the Replicated license file when it is uploaded to the storage bucket.
  EOD
  type        = string
}
variable "tfe_license_path" {
  description = <<-EOD
  The pathname of the Replicated license file that will be used to authorize the Terraform Enterprise installation.
  EOD
  type        = string
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}
