variable "region" {
  type        = string
  description = "The region to install into."
  default     = "us-central1"
}

variable "project" {
  type        = string
  description = "Name of the project to deploy into"
}

variable "creds" {
  type        = string
  description = "Name of credential file"
}

variable "primaryhostname" {
  type        = string
  description = "hostname prefix"
  default     = "ptfe-primary"
}

variable "domain" {
  type        = string
  description = "domain name"
}

variable "dnszone" {
  type        = string
  description = "Managed DNZ Zone name"
}

variable "frontenddns" {
  type        = string
  description = "DNS name for load balancer"
  default     = "tfe"
}

variable "zone" {
  type        = string
  description = "Preferred zone"
  default     = "us-central1-a"
}

variable "healthchk_ips" {
  type        = list(string)
  description = "List of gcp health check ips to allow through the firewall"
  default     = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
}

variable "subnet_range" {
  type        = string
  description = "CIDR range for subnet"
  default     = "10.1.0.0/16"
}

variable "postgresql_machinetype" {
  type        = string
  description = "Machine type to use for Postgres Database"
  default     = "db-f1-micro"
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
}

variable "name" {
  type        = string
  description = "Name to pass to your resources"
  default     = "ptfe"
}

