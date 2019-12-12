variable "dnszone" {
  type        = "string"
  description = "name of the managed dns zone"
}

variable "hostname" {
  type        = "string"
  description = "DNS hostname for load balancer, appended with the zone's domain"
}
