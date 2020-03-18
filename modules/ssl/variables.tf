variable "dns_fqdn" {
  description = "The fully qualified domain name for which the certificate will be issued."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}
