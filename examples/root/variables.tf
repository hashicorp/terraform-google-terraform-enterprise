variable "cloud_init_license_file" {
  description = "The pathname of a Replicated license file for the application."
  type        = string
}

variable "dns_managed_zone" {
  description = "The name of the managed DNS zone in which the application will be accessible."
  type        = string
}

variable "dns_managed_zone_dns_name" {
  description = "The fully qualified DNS name of the managed zone set by var.dns_managed_zone."
  type        = string
}

variable "prefix" {
  default     = "tfe-root-"
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}
