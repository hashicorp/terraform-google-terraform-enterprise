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

variable "ssl_certificate_name" {
  description = <<-EOD
  The name of an existing SSL certificate which will be used to authenticate connections to the load balancer.
  EOD
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
