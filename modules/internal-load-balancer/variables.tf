
variable "labels" {
  default     = {}
  description = "A collection of labels which will be applied to resources."
  type        = map(string)
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "primaries_instance_groups_self_links" {
  description = "The self links of the compute instance groups which comprise the primaries."
  type        = list(string)
}

variable "secondaries_instance_group_manager_instance_group" {
  description = "The compute instance group of the secondaries."
  type        = string
}

variable "ssl_certificate" {
  description = "The content of a SSL/TLS certificate to be attached to the load balancer. The content must be in PEM format. The certificate chain must be no greater than 5 certs long and it must include at least one intermediate cert."
  type = string
}

variable "ssl_certificate_private_key" {
  description = "The content of the write-only private key of var.ssl_certificate. The content must be in PEM format."
  type = string
}

variable "vpc_application_tcp_port" {
  description = "The application TCP port."
  type        = string
}

variable "vpc_install_dashboard_tcp_port" {
  description = "The install dashboard TCP port."
  type        = string
}

variable "vpc_network_self_link" {
  description = "The self link of the network to which resources will be attached."
  type        = string
}

variable "vpc_subnetwork_self_link" {
  description = "The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc_network_self_link."
  type        = string
}
