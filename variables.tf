locals {
  assistant_port                  = 23010
  rendered_secondary_machine_type = "${var.secondary_machine_type != "" ? var.secondary_machine_type : var.primary_machine_type }"
}

###################################################
# Required variables
###################################################

variable "certificate" {
  type        = "string"
  description = "Path to Certificate file or GCP certificate link"
}

variable "credentials_file" {
  type        = "string"
  description = "Path to credential file"
}

variable "domain" {
  type        = "string"
  description = "domain name"
}

variable "dns_zone" {
  type        = "string"
  description = "Managed DNS Zone name"
}

variable "frontend_dns" {
  type        = "string"
  description = "DNS name for load balancer"
}

variable "license_file" {
  type        = "string"
  description = "License file"
}

variable "project" {
  type        = "string"
  description = "Name of the project to deploy into"
}

variable "public_ip" {
  type        = "string"
  description = "the public IP for the load balancer to use"
}

variable "ssl_policy" {
  type        = "string"
  description = "SSL policy for the cert"
}

variable "subnet" {
  type        = "string"
  description = "name of the subnet to install into"
}

###################################################
# Optional External Services Variables
###################################################

variable "encryption_password" {
  type        = "string"
  description = "encryption password for the vault unseal key. save this!"
  default     = ""
}

variable "external_services" {
  type        = "string"
  description = "object store provider for external services. Allowed values: gcs"
  default     = ""
}

variable "install_type" {
  type        = "string"
  description = "Installation type, options are (poc or production). Switch to production for external services."
  default     = "poc"
}

variable "gcs_bucket" {
  type        = "string"
  description = "Name of the gcp storage bucket"
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

variable "postgresql_address" {
  type        = "string"
  description = "Database connection url"
  default     = ""
}

variable "postgresql_database" {
  type        = "string"
  description = "Database name"
  default     = ""
}

variable "postgresql_extra_params" {
  type        = "string"
  description = "Extra connection parameters such as ssl=true"
  default     = ""
}

variable "postgresql_password" {
  type        = "string"
  description = "Base64 encoded database password"
  default     = ""
}

variable "postgresql_user" {
  type        = "string"
  description = "Database username"
  default     = ""
}

###################################################
# Optional Airgap Variables
###################################################

variable "airgap_installer_url" {
  type        = "string"
  description = "URL to replicated's airgap installer package"
  default     = "https://install.terraform.io/installer/replicated-v5.tar.gz"
}

variable "airgap_package_url" {
  type        = "string"
  description = "airgap url"
  default     = "none"
}

###################################################
# Optional Variables
###################################################

variable "boot_disk_size" {
  type        = "string"
  description = "The size of the boot disk to use for the instances"
  default     = 40
}

variable "ca_cert" {
  type        = "string"
  description = "Path to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections"
  default     = ""
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

variable "primary_hostname" {
  type        = "string"
  description = "hostname prefix"
  default     = "ptfe-primary"
}

variable "primary_machine_type" {
  type        = "string"
  description = "Type of machine to use"
  default     = "n1-standard-4"
}

variable "region" {
  type        = "string"
  description = "The region to install into."
  default     = "us-central1"
}

variable "release_sequence" {
  type        = "string"
  description = "Replicated release sequence"
  default     = "latest"
}

variable "secondary_count" {
  type        = "string"
  description = "Number of secondary nodes to run"
  default     = "0"
}

variable "secondary_machine_type" {
  type        = "string"
  description = "Type of machine to use for secondary nodes, if unset, will default to primary_machine_type"
  default     = "n1-standard-4"
}

variable "zone" {
  type        = "string"
  description = "Preferred zone"
  default     = "us-central1-a"
}

###################################################
# Resources
###################################################

## random password for the installer dashboard
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
