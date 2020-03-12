variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "network_self_link" {
  description = "The URL of the network to which resources will be attached."
  type        = string
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the storage bucket"
  default     = {}
}

variable "postgresql_machinetype" {
  type        = string
  description = "Machine type to use for Postgres Database"
  default     = "db-custom-2-13312"
}

variable "postgresql_dbname" {
  type        = string
  description = "Name of Postgres Database"
  default     = "tfe"
}

variable "postgresql_user" {
  type        = string
  description = "Username for Postgres Database"
  default     = "tfe"
}

variable "postgresql_password" {
  type        = string
  description = "Password for Postgres Database"
  default     = ""
}

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
