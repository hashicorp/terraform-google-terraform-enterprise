# Required Variables
# ------------------
variable "fqdn" {
  description = "The fully qualified domain name of the load balancer."
  type        = string
}

variable "license_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded Replicated license file. The Terraform provider calls
  this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "active_active" {
  description = "A toggle which controls support for deploying Terraform Enterprise in Active/Active mode."
  type        = bool
}

variable "monitoring_enabled" {
  description = "A toggle which controls the use of Stackdriver monitoring on the compute instances."
  type        = bool
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "ca_certificate_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file for a Certificate Authority. The
  Terraform provider calls this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "proxy_ip" {
  description = "The IP address of a proxy server through which all traffic from the compute instances will be routed."
  type        = string
}

variable "no_proxy" {
  description = "Addresses which should not be accessed through the proxy server located at proxy_ip. This list will be combined with internal GCP addresses."
  type        = list(string)
}

# Base TFE Configs
# ----------------
variable "ca_certs" {
  description = <<-EOD
  A custom Certificate Authority certificate bundle to be used for authenticating connections with Terraform Enterprise.
  EOD
  type        = string
}

variable "capacity_concurrency" {
  description = "The maximum number of Terraform runs that will be executed concurrently on each compute instance."
  type        = string
}

variable "capacity_memory" {
  description = <<-EOD
  The maximum amount of memory that will be allocated to each Terraform run. The value must be expressed in megabytes.
  EOD
  type        = string
}

variable "custom_image_tag" {
  description = "The tag of the Docker image to be used as the custom Terraform Build Worker image."
  type        = string
}

variable "disk_path" {
  description = "The pathname of the directory in which Terraform Enterprise will store data on the compute instances."
  type        = string
}

variable "enable_metrics_collection" {
  description = <<-EOD
  A toggle to control the collection of metrics from Terraform Enterprise. The value must be \"1\" for
  true and \"0\" for false.
  EOD
  type        = string
  validation {
    condition     = contains(["1", "0"], var.enable_metrics_collection)
    error_message = "The enable_metrics_collection value must be \"1\" for true and \"0\" for false."
  }
}

variable "extra_no_proxy" {
  description = "A list of hosts for which Terraform Enterprise will not use a proxy to access."
  type        = list(string)
}

variable "hairpin_addressing" {
  description = "A toggle to control the use of hairpin addressing within the TFE deployment."
  type        = bool
}

variable "iact_subnet_list" {
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}

variable "iact_subnet_time_limit" {
  description = <<-EOD
  The time limit for IP addresses from iact_subnet_list to access the IACT. The value must be expressed in minutes.
  EOD
  type        = number
}

variable "disk_enabled" {
  description = "A toggle to control the use of Mounted Disk mode."
  type        = bool
}

variable "external_enabled" {
  description = "A toggle to control the use of External Services mode."
  type        = bool
}

variable "tbw_image" {
  description = <<-EOD
  An indicator of which type of Terraform Build Worker image will be used. The value must be one of: \"default_image\";
  \"custom_image\".
  EOD
  type        = string
  validation {
    condition     = contains(["default_image", "custom_image"], var.tbw_image)
    error_message = "The tbw_image value must be one of: \"default_image\"; \"custom_image\"."
  }
}

variable "tls_vers" {
  description = <<-EOD
  An indicator of the versions of TLS that will be supported by Terraform Enterprise. The value must be
  one of: \"tls_1_2_tls_1_3\"; \"tls_1_2\"; \"tls_1_3\".
  EOD
  type        = string
  validation {
    condition     = contains(["tls_1_2_tls_1_3", "tls_1_2", "tls_1_3"], var.tls_vers)
    error_message = "The tls_vers value must be one of: \"tls_1_2_tls_1_3\"; \"tls_1_2\"; \"tls_1_3\"."
  }
}

variable "trusted_proxies" {
  description = <<-EOD
  A list of IP address ranges which will be considered safe to ignore when evaluating the IP addresses of requests like
  those made to the IACT endpoint.
  EOD
  type        = list(string)
}

# Base External Configs
# ---------------------
variable "pg_dbname" {
  description = "The name of the PostgreSQL database in which Terraform Enterprise will store data."
  type        = string
}

variable "pg_extra_params" {
  description = <<-EOD
  Extra parameters to use when establishing connections to the PostgreSQL database; these parameters must be formatted
  like \"key1=value&key2=value2\".
  EOD
  type        = string
}

variable "pg_netloc" {
  description = "The private IP address of the SQL database instance."
  type        = string
}

variable "pg_password" {
  description = "The password of the PostgreSQL user which is authorized to manage the Terraform Enterprise database."
  type        = string
}

variable "pg_user" {
  description = "The name of the PostgreSQL user which is authorized to manage the Terraform Enterprise database."
  type        = string
}

variable "redis_host" {
  description = "The hostname of the Redis endpoint."
  type        = string
}

variable "redis_pass" {
  description = "The password for authenticating with the Redis endpoint."
  type        = string
}

variable "redis_port" {
  description = "The port number of the Redis endpoint."
  type        = string
}

variable "redis_use_password_auth" {
  description = "A toggle to control the use of authentication when connecting to the Redis endpoint."
  type        = bool
}

variable "redis_use_tls" {
  description = "A toggle to control the use of TLS when connecting to the Redis endpoint."
  type        = bool
}


# Replicated Configs
# ------------------
variable "airgap_url" {
  description = "The URL of the storage bucket object that comprises an airgap package."
  type        = string
}

variable "release_sequence" {
  description = "Release sequence of Terraform Enterprise to install."
  type        = number
}

variable "ssl_certificate_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file. The Terraform provider calls this
  value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "ssl_private_key_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM private key file. The Terraform provider calls this
  value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

# External GCP Configs
# --------------------
variable "gcs_bucket" {
  description = "The name of the storage bucket in which Terraform Enterprise will store data."
  type        = string
}

variable "gcs_credentials" {
  description = "The private key of the service account which is authorized to access the storage bucket."
  type        = string
}

variable "gcs_project" {
  description = "The ID of the project in which the storage bucket resides."
  type        = string
}
