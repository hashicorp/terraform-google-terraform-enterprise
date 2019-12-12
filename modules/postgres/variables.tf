variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "network_url" {
  type        = string
  description = "Google Compute Network url to connect with"
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
  default     = "ptfe"
}

variable "postgresql_user" {
  type        = string
  description = "Username for Postgres Database"
  default     = "tfepsqluser"
}

variable "postgresql_password" {
  type        = string
  description = "Password for Postgres Database"
  default     = ""
}
