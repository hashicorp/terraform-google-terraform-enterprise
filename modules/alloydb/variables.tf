# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "username" {
  description = "The name of the SQL user to be created in the AlloyDB database."
  type        = string
}

variable "postgres_version" {
  description = "The version of postgres to be installed on the SQL database instance."
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "network" {
  description = "The network."
  type = object({
    id = string
  })
}

variable "service_networking_connection" {
  description = "The service networking connection."
  type = object({
    vpc_connection = string
  })
}
