variable "postgresql_address" {
  description = "Address of PostgreSQL cluster to connect to"
}

variable "postgresql_database" {
  description = "Name of the database within the PostgreSQL cluster to use"
}

variable "postgresql_user" {
  description = "User to connect to PostgreSQL as"
}

variable "postgresql_password" {
  description = "Password for user to connect to PostgreSQL"
}

variable "postgresql_extra_params" {
  description = "Additional URL parameters to use when connecting to the PostgreSQL cluster"
  default     = ""
}

variable "storage_bucket" {
  description = "The storage bucket in which application data will be stored."
  type        = object({ name = string, project = string })
}

variable "storage_bucket_service_account_private_key" {
  description = "The private key of the service account which is authorized to manage the storage bucket."
  type = string
}
