variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "network_name" {
  description = "The name of the network to which resources will be attached."
  type        = string
}

variable "prefix" {
  type        = string
  description = "Name to attach to your VPC"
  default     = "tfe-"
}

variable "primary_service_account_email" {
  type        = string
  description = "The email address of the primary service account."
}

variable "project" {
  type        = string
  description = "The ID of the project in which the resources will be created."
}

variable "proxy_service_account_email" {
  type        = string
  description = "The email address of the proxy service account."
}

variable "secondary_service_account_email" {
  type        = string
  description = "The email address of the secondary service account."
}

variable "subnetwork_ip_cidr_range" {
  type        = string
  description = "The IP address range of the TFE subnetwork expressed in CIDR format."
}

variable "ports" {
  type = object(
    {
      application       = object({ tcp = list(string) })
      cluster_assistant = object({ tcp = list(string) })
      etcd              = object({ tcp = list(string) })
      kubelet           = object({ tcp = list(string) })
      kubernetes        = object({ tcp = list(string) })
      replicated        = object({ tcp = list(string) })
      replicated_ui     = object({ tcp = list(string) })
      ssh               = object({ tcp = list(string) })
      weave             = object({ tcp = list(string), udp = list(string) })
    }
  )
  description = "The ports over which network traffic will travel, organized by services and protocols."
}
