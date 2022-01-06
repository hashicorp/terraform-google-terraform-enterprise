variable "ca_certificate" {
  default     = null
  description = "The secret identity and data of a PEM certificate file for a Certificate Authority."
  type = object({
    id   = string
    data = string
  })
}

variable "ca_private_key" {
  default     = null
  description = "The secret identity and data of a PEM private key file for a Certificate Authority."
  type = object({
    id   = string
    data = string
  })
}

variable "labels" {
  default     = {}
  type        = map(string)
  description = "Labels to apply to resources"
}

variable "license" {
  default     = null
  description = "The secret identity and local path of a Replicated license file."
  type = object({
    id   = string
    path = string
  })
}

variable "ssl_certificate" {
  default     = null
  description = "The secret identity and data of a PEM certificate file."
  type = object({
    id   = string
    data = string
  })
}

variable "ssl_private_key" {
  default     = null
  description = "The secret identity and data of a PEM private key file."
  type = object({
    id   = string
    data = string
  })
}
