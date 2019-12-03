locals {
  assistant_port                  = 23010
  rendered_secondary_machine_type = "${var.secondary_machine_type != "" ? var.secondary_machine_type : var.primary_machine_type }"
  internal_airgap_url             = "http://${var.prefix}-primary-0-${random_string.postfix.result}:${local.assistant_port}/setup-files/replicated.tar.gz?token=${random_string.setup_token.result}"
  encryption_password             = "${var.encryption_password != "" ? var.encryption_password : random_string.default_enc_password.result}"
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
# Optional Variables you should probably set
###################################################

variable "encryption_password" {
  type        = "string"
  description = "encryption password for the vault unseal key. save this!"
  default     = ""
}

variable "prefix" {
  type        = "string"
  description = "Resource and instance prefix"
  default     = "tfe"
}

variable "primary_count" {
  type        = "string"
  description = "Number of primary nodes to run, must be odd number - 3 or 5 recommended."
  default     = "3"
}

variable "max_secondaries" {
  type        = "string"
  description = "The maximum number of secondaries in the autoscaling group"
  default     = "3"
}

variable "min_secondaries" {
  type        = "string"
  description = "The minimum number of secondaries in the autoscaling group"
  default     = "0"
}

variable "autoscaler_cpu" {
  type        = "string"
  description = "The cpu threshold at which the autoscaling group to build another instance"
  default     = "0.7"
}

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

###################################################
# Optional External Services Variables
###################################################

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
  description = "Project name where the bucket resides, if left blank will use project provided above"
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
  default     = "none"
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

variable "ptfe_install_url" {
  type        = "string"
  description = "Location of the ptfe install tool zip file"
  default     = "https://install.terraform.io/installer/ptfe-0.1.zip"
}

variable "jq_url" {
  type        = "string"
  description = "Location of the jq package"
  default     = "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64"
}

###################################################
# Optional Variables
###################################################

variable "boot_disk_size" {
  type        = "string"
  description = "The size of the boot disk to use for the instances"
  default     = 40
}

variable "ca_bundle_url" {
  type        = "string"
  description = "URL to Custom CA bundle used for outgoing connections"
  default     = "none"
}

variable "image_family" {
  type        = "string"
  description = "The image family, choose from ubuntu-1604-lts, ubuntu-1804-lts, or rhel-7"
  default     = "ubuntu-1804-lts"
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

variable "http_proxy_url" {
  type        = "string"
  description = "HTTP(S) proxy url"
  default     = "none"
}

variable "release_sequence" {
  type        = "string"
  description = "Replicated release sequence"
  default     = "latest"
}

variable "dns_project" {
  type        = "string"
  description = "Name of project where the DNS zone resides"
  default     = ""
}

variable "weave_cidr" {
  type        = "string"
  description = "Specify a non-standard CIDR range for weave. The default is 10.32.0.0/12"
  default     = ""
}

variable "repl_cidr" {
  type        = "string"
  description = "Specify a non-standard CIDR range for the replicated services. The default is 10.96.0.0/12"
  default     = ""
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

resource "random_string" "default_enc_password" {
  length  = 32
  upper   = true
  special = false
}
