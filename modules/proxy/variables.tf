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

variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "ip_cidr_range" {
  description = "The range from which IP addresses will be assigned to resources. The range must be expressed in CIDR notation."
  type        = string
}

variable "ports" {
  type        = list(number)
  description = "Only packets addressed to these ports will be forwarded through the proxy. var.k8s_api_port will be added to this list."
  default     = [80, 443, 23010]
}

variable "network" {
  description = "The name or the self link of the network to which resources will be attached."
}

variable "primaries_instance_group" {
  type        = string
  description = "GCP Instance Group for the primaries"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "subnetwork" {
  description = "The name or the self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.network."
  type        = string
}

variable "subnetwork_project" {
  description = "The ID of the project in which var.subnetwork exists."
  type        = string
}
