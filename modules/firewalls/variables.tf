variable "network_name" {
  description = "The name of the network to which resources will be attached."
  type        = string
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

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "primary_service_account_email" {
  description = "The email address of the primary service account."
  type        = string
}

variable "proxy_service_account_email" {
  description = "The email address of the proxy service account."
  type        = string
}

variable "secondary_service_account_email" {
  description = "The email address of the secondary service account."
  type        = string
}

variable "subnetwork_ip_cidr_range" {
  description = "The IP address range of the TFE subnetwork expressed in CIDR format."
  type        = string
}
