# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "dbname" {
  description = "The name of the AlloyDB database to be created."
  type        = string
}

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

variable "service_networking_connection" {
  description = "The private service networking connection that will connect PostgreSQL to the network."
  type = object({
    network = string
  })
}