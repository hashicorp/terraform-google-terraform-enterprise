variable "cluster_assistant_port" {
  type        = number
  description = "The port of the Cluster Assistant."
  default     = 23010
}

variable "k8s_api_port" {
  type        = number
  description = "The port of the Kubernetes API."
  default     = 6443
}

variable "vpc_subnetwork_ip_cidr_range" {
  description = "The range from which IP addresses will be assigned to resources, expressed in CIDR notation. The range must be part of var.vpc_subnetwork_self_link."
  type        = string
}

variable "ports" {
  type        = list(number)
  description = "Only packets addressed to these ports will be forwarded through the internal load balancer. var.k8s_api_port will be added to this list."
  default     = [80, 443, 23010]
}

variable "vpc_network_self_link" {
  description = "The self link of the network to which resources will be attached."
  type        = string
}

variable "primary_cluster_instance_group_self_link" {
  type        = string
  description = "GCP Instance Group for the primaries"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "vpc_subnetwork_self_link" {
  description = "The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc_network_self_link."
  type        = string
}

variable "vpc_subnetwork_project" {
  description = "The ID of the project in which var.vpc_subnetwork_self_link exists."
  type        = string
}
