variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "ssl_certificate_name" {
  description = <<-EOD
  The name of an existing SSL certificate which will be used to authenticate connections to the load balancer.
  EOD
  type        = string
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
}

variable "google" {
  description = "Attributes of the Google Cloud account which will host the test infrastructure."
  type = object({
    credentials     = string
    project         = string
    region          = string
    zone            = string
    service_account = string
  })
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "airgap_url" {
  description = "The URL of the storage bucket object that comprises an airgap package."
  type        = string
}