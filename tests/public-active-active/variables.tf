variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}

variable "iact_subnet_list" {
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}

variable "ssl_certificate_name" {
  description = <<-EOD
  The name of an existing SSL certificate which will be used to authenticate connections to the load balancer.
  EOD
  type        = string
}

variable "license_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded Replicated license file. The Terraform provider calls
  this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}
