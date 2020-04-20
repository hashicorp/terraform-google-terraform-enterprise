variable "availability_type" {
  default     = "ZONAL"
  description = "A specifier which determines if the database compute instance will be set up for high availability (REGIONAL) or single zone (ZONAL)."
  type        = string
}

variable "backup_start_time" {
  default     = null
  description = "The time at which to start database compute instance backups, expressed in HH:MM notation."
  type        = string
}

variable "labels" {
  default     = {}
  description = "A collection of labels which will be applied to the database compute instance."
  type        = map(string)
}

variable "machine_type" {
  default     = "db-custom-2-13312"
  description = "The identifier of the set of virtualized hardware resources which will be available to the database compute instance."
  type        = string
}

variable "name" {
  default     = "tfe"
  description = "The name of the database which will be used to store application data."
  type        = string
}

variable "vpc_network_self_link" {
  description = "The self link of the network to which resources will be attached."
  type        = string
}

variable "password" {
  default     = null
  description = "The password which will be used for authentication with the database. If no password is set then a password will be generated randomly."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "vpc_address_name" {
  type = string
}

variable "username" {
  default     = "tfe"
  description = "The username which will be used for authentication with the database."
  type        = string
}
