variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "memory_size" {
  description = <<-EOD
  The amount of memory which will be allocated to the Redis instance; this value must be expressed in gibibytes.
  EOD
  type        = number
}

variable "service_networking_connection" {
  description = "The private service networking connection that will connect Redis to the network."
  type = object({
    network = string
  })
}

variable "auth_enabled" {
  description = "A toggle to control authentication on the Redis instance."
  type        = bool
}

variable "transit_encryption_mode" {
  description = "The TLS mode of the Redis instance."
  type        = string
  default     = "DISABLED"
  validation {
    condition     = contains(["SERVER_AUTHENTICATION", "DISABLED"], var.transit_encryption_mode)
    error_message = "Supported values are 'SERVER_AUTHENTICATION' or 'DISABLED'."
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
}
