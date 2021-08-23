variable "cloud_dns" {
  description = "The Cloud DNS module which contains the managed zone in which a record will be created."
  type = object({
    domain = string
    name   = string
  })
}

variable "license_secret" {
  description = "The Secret Manager secret which comprises the Base64 encoded Replicated license file."
  type = object({
    secret_id = string
  })
}

variable "mitmproxy_certificate_secret" {
  description = "The Secret Manager secret which comprises the Base64 encoded PEM certificate for mitmproxy."
  type = object({
    secret_id = string
  })
}

variable "mitmproxy_private_key_secret" {
  description = "The Secret Manager secret which comprises the Base64 encoded PEM private key for mitmproxy."
  type = object({
    secret_id = string
  })
}

variable "ssl_certificate" {
  description = "The SSL certificate which will be used to authenticate connections to Terraform Enterprise."
  type = object({
    name = string
  })
}
