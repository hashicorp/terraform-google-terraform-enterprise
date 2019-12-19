variable "project" {
  type        = string
  description = "Name of the project to deploy into"
}

variable "credentials" {
  type        = string
  description = "Path to GCP credentials .json file"
}

variable "dnszone" {
  type        = string
  description = "Name of the managed dns zone to create records into"
}

variable "license_file" {
  type        = string
  description = "Replicated license file"
}

variable "hostname" {
  type        = string
  description = "DNS hostname for load balancer, appended with the zone's domain"
  default     = "tfe"
}

variable "region" {
  type        = string
  description = "The region to install into."
  default     = "us-central1"
}

variable "install_id" {
  type        = string
  description = "Identifier to use in names to identify resources"
  default     = ""
}

variable "prefix" {
  type        = string
  description = "Prefix to apply to all resources names"
  default     = "tfe-"
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
