variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "ports" {
  type = object(
    {
      cluster_assistant = object({ tcp = list(string) }),
      kubernetes        = object({ tcp = list(string) })
    }
  )
  description = "The ports over which network traffic will travel, organized by services and protocols."
}

variable "project" {
  type        = string
  description = "Name of the project to deploy into"
}

variable "service_account_email" {
  type        = string
  description = "The email address of the service account which will be attached to the proxy compute instances."
}

variable "subnetwork" {
  type        = object({ ip_cidr_range = string, network = string, self_link = string })
  description = "GCP Subnetwork for Load Balancer"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "primary_instance_group" {
  type        = string
  description = "GCP Instance Group for the primaries"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}
