locals {
  assistant_port                  = 23010
  rendered_secondary_machine_type = "${var.secondary_machine_type != "" ? var.secondary_machine_type : var.primary_machine_type }"
}
###################################################
# Required variables
###################################################
variable "project" {
  type        = "string"
  description = "Name of the project to deploy into"
}

variable "creds" {
  type        = "string"
  description = "Name of credential file"
}

variable "subnet" {
  type        = "string"
  description = "name of the subnet to install into"
}

variable "publicip" {
  type        = "string"
  description = "the public IP for the load balancer to use"
}

variable "frontenddns" {
  type        = "string"
  description = "DNS name for load balancer"
}

variable "domain" {
  type        = "string"
  description = "domain name"
}

variable "dnszone" {
  type        = "string"
  description = "Managed DNS Zone name"
}

variable "license_file" {
  type        = "string"
  description = "License file"
}

variable "cert" {
  type        = "string"
  description = "Certificate file or gcp cert link"
}

variable "sslpolicy" {
  type        = "string"
  description = "SSL policy for the cert"
}

###################################################
# Optional External Services Variables
###################################################

variable "external_services" {
  type        = "string"
  description = "object store provider for external services. Allowed values: gcs"
  default     = ""
}

variable "encpasswd" {
  type        = "string"
  description = "encryption password for the vault unseal key. save this!"
  default     = ""
}

variable "install_type" {
  type        = "string"
  description = "Switch to production for external services. Defaults to demo mode"
  default     = "poc"
}

variable "pg_user" {
  type        = "string"
  description = "Database username"
  default     = ""
}

variable "pg_password" {
  type        = "string"
  description = "Base64 encoded database password"
  default     = ""
}

variable "pg_netloc" {
  type        = "string"
  description = "Database connection url"
  default     = ""
}

variable "pg_dbname" {
  type        = "string"
  description = "Database name"
  default     = ""
}

variable "pg_extra_params" {
  type        = "string"
  description = "Extra connection parameters such as ssl=true"
  default     = ""
}

variable "gcs_credentials" {
  type        = "string"
  description = "Base64 encoded credentials json to access your gcp storage bucket. Run base64 -i <creds.json> -o <credsb64.json> and then copy the contents of the file into the variable"
  default     = ""
}

variable "gcs_project" {
  type        = "string"
  description = "Project name where the bucket resides"
  default     = ""
}

variable "gcs_bucket" {
  type        = "string"
  description = "Name of the gcp storage bucket"
  default     = ""
}

###################################################
# Optional Airgap Variables
###################################################

variable "airgapurl" {
  type        = "string"
  description = "airgap url"
  default     = "none"
}

variable "airgap_installer_url" {
  type        = "string"
  description = "URL to replicated's airgap installer package"
  default     = "https://install.terraform.io/installer/replicated-v5.tar.gz"
}

###################################################
# Optional Variables
###################################################

variable "region" {
  type        = "string"
  description = "The region to install into."
  default     = "us-central1"
}

variable "zone" {
  type        = "string"
  description = "Preferred zone"
  default     = "us-central1-a"
}

variable "primary_machine_type" {
  type        = "string"
  description = "Type of machine to use"
  default     = "n1-standard-4"
}

variable "secondary_machine_type" {
  type        = "string"
  description = "Type of machine to use for secondary nodes, if unset, will default to primary_machine_type"
  default     = "n1-standard-4"
}

variable "image_family" {
  type        = "string"
  description = "The image family, choose from ubuntu-1604-lts, ubuntu-1804-lts, or rhel-7"
  default     = "ubuntu-1804-lts"
}

variable "primary_count" {
  type        = "string"
  description = "Number of primary nodes to run, must be odd number"
  default     = "1"
}

variable "worker_count" {
  type        = "string"
  description = "Number of secondary nodes to run"
  default     = "0"
}

variable "primaryhostname" {
  type        = "string"
  description = "hostname prefix"
  default     = "ptfe-primary"
}

variable "release_sequence" {
  type        = "string"
  description = "Replicated release sequence"
  default     = "latest"
}

###################################################
# Resources
###################################################

## random password for the replicated console
resource "random_pet" "console_password" {
  length = 3
}

resource "random_string" "bootstrap_token_id" {
  length  = 6
  upper   = false
  special = false
}

resource "random_string" "bootstrap_token_suffix" {
  length  = 16
  upper   = false
  special = false
}

resource "random_string" "setup_token" {
  length  = 32
  upper   = false
  special = false
}
