variable "dns_fqdn" {
  description = "The routable hostname of the application endpoint."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "primaries_instance_group_self_link" {
  description = "The self link of the compute instance group for the primaries."
  type        = string
}

variable "secondaries_instance_group_manager_instance_group" {
  description = "The compute instance group of the secondaries."
  type        = string
}

variable "ssl_certificate_self_link" {
  description = "The self link of the managed SSL certificate which will be applied to the load balancer."
  type        = string
}

variable "ssl_policy_self_link" {
  description = "The self link of a compute SSL policy for the SSL certificate."
  type        = string
}

variable "vpc_address" {
  description = "The address which will be assigned to the load balancer."
  type        = string
}

variable "vpc_application_tcp_port" {
  description = "The application TCP port."
  type        = string
}

variable "vpc_install_dashboard_tcp_port" {
  description = "The install dashboard TCP port."
  type        = string
}
