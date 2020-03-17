variable "dnszone" {
  type        = string
  description = "Name of the managed dns zone to create records into"
}

variable "cloud_init_license_file" {
  description = "The pathname of a Replicated license file for the application."
  type        = string
}
