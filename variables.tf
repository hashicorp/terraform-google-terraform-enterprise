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
  default     = "tfe-"
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

###################################################
# Postgresql options
###################################################

variable "postgresql_availability_type" {
  type        = string
  description = "This specifies whether a PostgreSQL instance should be set up for high availability (REGIONAL) or single zone (ZONAL)"
  default     = "ZONAL"
}

variable "postgresql_backup_start_time" {
  type        = string
  description = "HH:MM format time indicating when backup configuration starts."
  default     = ""
}
