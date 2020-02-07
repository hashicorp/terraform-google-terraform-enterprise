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

variable "ports" {
  type        = list(number)
  description = <<-EOD
  Only packets addressed to these ports will be forwarded through the proxy. var.k8s_api_port will be added to this list.
  EOD
  default     = [80, 443, 23010]
}

variable "project" {
  type        = string
  description = "Name of the project to deploy into"
}

variable "subnet" {
  type        = object({ ip_cidr_range = string, network = string, self_link = string })
  description = "GCP Subnetwork for Load Balancer"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "primaries" {
  type        = string
  description = "GCP Instance Group for the primaries"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}
