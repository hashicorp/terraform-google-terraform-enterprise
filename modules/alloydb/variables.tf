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
  default     = "POSTGRES_16" 
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "availability_type" {
  description = "The availability type of the SQL database instance."
  type        = string
}

variable "network" {
  description = "The network."
  type = object({
    id = string
  })
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
}

variable "service_networking_connection" {
  description = "The private service networking connection that will connect PostgreSQL to the network."
  type = object({
    network = string
  })
}

variable "region" {
  description = "The region in which the AlloyDB cluster will be created."
  type        = string
  default     = "us-east4"
}
