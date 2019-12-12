variable "install_id" {
  type        = string
  description = "Identifier for install to apply to resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "tfe-"
}

variable "project" {
  type        = string
  description = "GCP Project to find the DNS Zone"
}

variable "dnszone" {
  type        = string
  description = "Name of the DNS Zone to add records to"
}

variable "primaries" {
  type = list(
    object({
      hostname = string,
      address  = string,
    })
  )

  description = "Information about primaries to add DNS"
}
