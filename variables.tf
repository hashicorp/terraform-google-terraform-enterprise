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

###################################################
# Cluster secondary scaling
###################################################

variable "max_secondaries" {
  type        = string
  description = "The maximum number of secondaries in the autoscaling group"
  default     = "3"
}

variable "min_secondaries" {
  type        = string
  description = "The minimum number of secondaries in the autoscaling group"
  default     = "0"
}

variable "autoscaler_cpu_threshold" {
  type        = string
  description = "The cpu threshold at which the autoscaling group to build another instance"
  default     = "0.7"
}
