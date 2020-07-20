variable "cloud_init_license_file" {
  description = "The pathname of a Replicated license file for the application."
  type        = string
}

variable "dns_managed_zone" {
  description = "The name of the managed DNS zone in which the application will be accessible."
  type        = string
}

variable "dns_managed_zone_dns_name" {
  description = "The fully qualified DNS name of the managed zone set by var.dns_managed_zone."
  type        = string
}

variable "labels" {
  default     = {}
  description = "A collection of labels which will be applied to resources."
  type        = map(string)
}

variable "prefix" {
  default     = "tfe-"
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "secondaries_max_instances" {
  default     = 5
  description = "The maximum count of compute instances to which the secondaries may scale. The default value is derived from the secondaries submodule."
  type        = number
}

variable "secondaries_min_instances" {
  default     = 1
  description = "The minimum count of compute instances to which the secondaries may scale. The default value is derived from the secondaries submodule."
  type        = number
}

variable "release_sequence" {
  default     = ""
  description = "The sequence identifier of the TFE version to which the cluster will be pinned."
  type        = string
}
