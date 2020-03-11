variable "database" {
  default     = { name = "tfe", user_name = "tfe", user_password = "" }
  description = "Attributes for the database: name is the name of the database; user_name is the name of the database user; user_password is the password of the database user."
  type        = object({ name = string, user_name = string, user_password = string })
}

variable "instance" {
  default     = { availability_type = "ZONAL", backup_start_time = "", labels = {}, tier = "db-custom-2-13312" }
  description = "Attributes for the database compute instance: availability_zone is specifier which determines if the instance will be set up for high availability (REGIONAL) or single zone (ZONAL); instance_backup_start_time is the time at which to start instance backups, expressed in HH:MM notation; labels are the labels which will be applied to the instance; tier is the identifier of the machine type of the instance."
  type        = object({ availability_type = string, backup_start_time = string, labels = map(string), tier = string })
}

variable "network_name" {
  description = "The name of the network to which resources will be attached."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}
