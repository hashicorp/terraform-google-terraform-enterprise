variable "publicIP" {
  type        = "string"
  description = "External-facing IP address for PTFE application"
}

variable "cert" {
  type        = "string"
  description = "certificate for the load balancer"
}

variable "instance_group" {
  type        = "string"
  description = "primary instance group"
}

variable "domain" {
  type        = "string"
  description = "domain"
}

variable "sslpolicy" {
  type        = "string"
  description = "SSL policy for the cert"
}

variable "frontenddns" {
  type        = "string"
  description = "front end url name"
}

variable "prefix" {
  type        = "string"
  description = "Prefix for resource names"
}
