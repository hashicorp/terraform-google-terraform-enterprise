variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
}

variable "instance_group" {
  description = "The self link of an instance group which will serve traffic to the load balancer."
  type        = string
}

variable "ip_address" {
  description = "The IP address which will be assigned to the load balancer."
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

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
}

variable "subnetwork" {
  description = "The subnetwork to which the load balancer will be attached."
  type = object({
    self_link = string
  })
}
