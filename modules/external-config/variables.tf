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

variable "gcs_credentials" {
  description = "The credentials JSON object to authenticate to GCS with"
}

variable "gcs_project" {
  description = "The Google Cloud project to access the GCS bucket within"
}

variable "gcs_bucket" {
  description = "The Google Cloud Storage bucket to store data in"
}
