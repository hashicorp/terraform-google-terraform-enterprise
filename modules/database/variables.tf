variable "dbname" {
  description = "The name of the PostgreSQL database to be created."
  type        = string
}

variable "username" {
  description = "The name of the SQL user to be created in the PostgreSQL database."
  type        = string
}

variable "machine_type" {
  description = "The machine type of the SQL database instance."
  type        = string
}

variable "availability_type" {
  description = "The availability type of the SQL database instance."
  type        = string
}

variable "disk_size" {
  description = "The size of the SQL database instance data disk, expressed in gigabytes."
  type        = number
}

variable "postgres_version" {
  description = "The version of PostgreSQL to be installed on the SQL database instance."
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "backup_start_time" {
  description = "The time at which a daily database backup will be performed."
  type        = string
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
}

variable "service_networking_connection" {
  description = "The private service networking connection that will connect PostgreSQL to the network."
  type = object({
    network = string
  })
}
