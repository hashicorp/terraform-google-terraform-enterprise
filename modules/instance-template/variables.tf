locals {
  assistant_port = 23010
}

variable "region" {
  type        = "string"
  description = "The region to install into."
}

variable "secondary_machine_type" {
  type        = "string"
  description = "Type of machine to use"
}

variable "ptfe_subnet" {
  type        = "string"
  description = "subnet to deploy into"
}

variable "cluster_endpoint" {
  type        = "string"
  description = "the cluster endpoint"
}

variable "bootstrap_token_id" {
  type        = "string"
  description = "bootstrap token id"
}

variable "bootstrap_token_suffix" {
  type        = "string"
  description = "bootstrap token suffix"
}

variable "setup_token" {
  type        = "string"
  description = "setup token"
}

variable "image_family" {
  type        = "string"
  description = "image family"
}

variable "boot_disk_size" {
  type        = "string"
  description = "The size of the boot disk to use for the instances"
  default     = 40
}

variable "ptfe_install_url" {
  type        = "string"
  description = "Location of the ptfe install tool zip file"
}

variable "jq_url" {
  type        = "string"
  description = "Location of the jq package"
}

variable "repl_data" {
  type        = "string"
  description = "console"
}

variable "release_sequence" {
  type        = "string"
  description = "Replicated release sequence"
}

variable "prefix" {
  type        = "string"
  description = "Prefix for resource names"
}

variable "ca_bundle_url" {
  type        = "string"
  description = "URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections"
  default     = "none"
}

variable "http_proxy_url" {
  type        = "string"
  description = "HTTP(S) proxy url"
}

variable "assistant-host" {}

variable "assistant-token" {}

variable "b64-license" {}

variable "airgap_package_url" {}

variable "airgap_installer_url" {}

variable "encryption_password" {}

variable "postgresql_user" {}

variable "postgresql_password" {}

variable "postgresql_address" {}

variable "postgresql_database" {}

variable "postgresql_extra_params" {}

variable "gcs_credentials" {}

variable "credentials_file" {}

variable "project" {}

variable "gcs_project" {}

variable "gcs_bucket" {}

variable "weave_cidr" {}

variable "repl_cidr" {}
