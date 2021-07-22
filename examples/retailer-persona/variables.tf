variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "tfe_license_path" {
  description = <<-EOD
  The pathname of the Replicated license file that will be used to authorize the Terraform Enterprise installation.
  EOD
  type        = string
}
