variable "airgap_package_url" {
  default     = ""
  description = "The URL of an airgap package which contains a TFE release."
  type        = string
}

variable "airgap_installer_url" {
  default     = "https://install.terraform.io/installer/replicated-v5.tar.gz"
  description = "The URL of an airgap package which contains the cluster installer."
  type        = string
}

variable "application_config" {
  description = "The application configuration."
  type        = map(map(string))
}

variable "custom_ca_cert_url" {
  default     = ""
  description = "The URL of a certificate authority bundle which contains custom certificates to be trusted by the application."
  type        = string
}

variable "distribution" {
  default     = "ubuntu"
  description = "The type of Linux distribution which will be running on the machines."
  type        = string
}

variable "internal_load_balancer_address" {
  description = "The IP address of the internal load balancer."
  type        = string
}

variable "license_file" {
  description = "The pathname of a Replicated license file for the application."
  type        = string
}

variable "proxy_url" {
  default     = ""
  description = "The URL of a proxy through which application traffic will be routed."
  type        = string
}

variable "ptfe_url" {
  default     = "https://install.terraform.io/installer/ptfe-0.1.zip"
  description = "The URL of the cluster installer tool."
  type        = string
}

variable "release_sequence" {
  default     = "latest"
  description = "The sequence identifier of the TFE version to which the cluster will be pinned."
  type        = string
}

variable "repl_cidr" {
  default     = ""
  description = "A custom IP address range over which Replicated will communicate, expressed in CIDR notation."
  type        = string
}

variable "ssh_import_id_usernames" {
  default     = []
  description = "The usernames associated with SSH keys which will be imported from a keyserver to all machines. Refer to the cloud-init documentation for more information: https://cloudinit.readthedocs.io/en/latest/topics/modules.html#ssh-import-id"
  type        = list(string)
}

variable "weave_cidr" {
  default     = ""
  description = "A custom IP address range over which Weave will communicate, expressed in CIDR notation."
  type        = string
}
