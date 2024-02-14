# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "enable_active_active" {
  description = "A toggle which controls support for deploying Terraform Enterprise in Active/Active mode."
  type        = bool
}

variable "is_replicated_deployment" {
  type        = bool
  description = "TFE will be installed using a Replicated license and deployment method."
}

variable "namespace" {
  description = "A prefix will be applied to all resource names."
  type        = string
}

variable "subnet_range" {
  description = <<-EOD
  The range of IP addresses for the subnetwork to which Terraform Enterprise will be attached; this
  range must be expressed in CIDR notation.
  EOD
  type        = string
}

variable "reserve_subnet_range" {
  description = <<-EOD
  The range of IP addresses for the subnetwork that will be reserved for internal HTTPS load balancing; this range must
  be expressed in CIDR notation.
  EOD
  type        = string
}

variable "firewall_ports" {
  description = <<-EOD
  A list of port numbers in addition to those required by Terraform Enterprise that will open to traffic from var.
  ip_allow_list.
  EOD
  type        = list(string)
}

variable "healthcheck_ips" {
  description = <<-EOD
  A list of IP address ranges from which traffic will be authorized to access the health check endpoint of the load
  balancer; these ranges must be expressed in CIDR notation.
  EOD
  type        = list(string)
}

variable "service_account" {
  description = <<-EOD
  The service account which is assigned to the Terraform Enterprise compute instances.
  EOD
  type = object({
    email = string
  })
}

variable "ip_allow_list" {
  description = <<-EOD
  A list of IP address ranges from which traffic will be authorized to access the Terraform Enterprise user interfaces;
  these ranges must be expressed in CIDR notation.
  EOD
  type        = list(string)
}

variable "ssh_source_ranges" {
  description = "The source IP address ranges from which SSH traffic will be permitted; these ranges must be expressed in CIDR notation."
  type        = list(string)
}

variable "is_teardown_run" {
  default = false
  type    = bool
}
