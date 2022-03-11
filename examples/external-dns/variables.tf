variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license."
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "dns_create_record" {
  description = "A toggle to control the creation of a DNS record for the load balancer IP address."
  type        = bool
}
