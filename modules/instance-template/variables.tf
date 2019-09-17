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

variable "install_type" {
  type        = "string"
  description = "type of install - poc or production"
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

variable "ca_cert_url" {
  type        = "string"
  description = "URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections"
  default     = "none"
}