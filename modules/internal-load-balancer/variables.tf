variable "labels" {
  default     = {}
  description = "A collection of labels which will be applied to the compute instances."
  type        = map(string)
}

variable "port_cluster_assistant_tcp" {
  description = "The port over which Cluster Assistant TCP traffic will travel."
  type        = string
}

variable "port_kubernetes_tcp" {
  description = "The port over which Kubernetes TCP traffic will travel."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "vpc_subnetwork_ip_cidr_range" {
  description = "The range from which IP addresses will be assigned to resources, expressed in CIDR notation. The range must be part of var.vpc_subnetwork_self_link."
  type        = string
}

variable "primaries_instance_group_self_link" {
  type        = string
  description = "The self link of the instance group for the primaries."
}

variable "service_account_email" {
  type        = string
  description = "The email address of the service account which will be associated with the proxy compute instances."
}

variable "vpc_network_self_link" {
  description = "The self link of the network to which resources will be attached."
  type        = string
}

variable "vpc_subnetwork_self_link" {
  description = "The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc_network_self_link."
  type        = string
}

variable "vpc_subnetwork_project" {
  description = "The ID of the project in which var.vpc_subnetwork_self_link exists."
  type        = string
}
