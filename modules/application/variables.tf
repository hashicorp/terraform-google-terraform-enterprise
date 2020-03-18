variable "additional_no_proxy" {
  default     = []
  description = "A list of hostnames to which traffic from the application will not be proxied."
  type        = list(string)
}

variable "ca_certs" {
  default     = null
  description = "The contents of a certificate authority bundle which contains custom certificates to be trusted by the application, expressed as the concatenated contents of one or more certificate files."
  type        = string
}

variable "capacity_memory" {
  default     = null
  description = "The amount of memory to allocate for each Terraform run, expressed in units of megabytes."
  type        = number
}

variable "custom_image_name" {
  default     = null
  description = "The name of a custom Docker image which will be used to provision Terraform Build Workers. var.tbw_image must be set to 'custom_image' in order for this variable to be used."
  type        = string
}

variable "dns_fqdn" {
  description = "The routable hostname of the application endpoint."
  type        = string
}

variable "enc_password" {
  default     = null
  description = "The password which will be used to encrypt sensitive data at rest."
  type        = string
}

variable "extern_vault_addr" {
  default     = null
  description = "The URL of the external Vault cluster. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "extern_vault_path" {
  default     = null
  description = "The path to the AppRole auth method on the external Vault cluster. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "extern_vault_role_id" {
  default     = null
  description = "The RoleID of the AppRole to be used for authentication with the external Vault cluster. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "extern_vault_secret_id" {
  default     = null
  description = "The SecretID of the AppRole to be used for authentication with the external Vault cluster. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "extern_vault_token_renew" {
  default     = null
  description = "The period of time between renewals of the external Vault cluster token, expressed in units of seconds. var.extern_vault_addr must be set in order for this variable to be used."
  type        = number
}

variable "iact_subnet_list" {
  default     = []
  description = "A list of IP address ranges from which access to the Initial Admin Creation Token API will be authorized, expressed in CIDR notation."
  type        = list(string)
}

variable "iact_subnet_time_limit" {
  description = "The amount of time to allow for access to the Initial Admin Creation Token API from var.iact_subnet_list, expressed in units of minutes. A value of 'unlimited' will disable the limit."
  default     = null
  type        = string
}

variable "postgresql_database_name" {
  description = "The name of the database on the PostgreSQL cluster which will be used to store application data."
  type        = string
}

variable "postgresql_database_instance_address" {
  description = "The hostname and optional port of the PostgreSQL cluster, expressed in hostname:port notation."
  type        = string
}

variable "postgresql_extra_params" {
  default     = {}
  description = "A collection of additional URL parameters which will be used when connecting to the PostgreSQL cluster."
  type        = map(string)
}

variable "postgresql_user_password" {
  description = "The password which will be used to authenticate with the PostgreSQL cluster."
  type        = string
}

variable "postgresql_user_name" {
  description = "The username which will be used to authenticate with the PostgreSQL cluster."
  type        = string
}

variable "service_account_storage_key_private_key" {
  description = "The private key of the service account which is authorized to manage the storage bucket, expressed in Base64 encoding."
  type        = string
}

variable "storage_bucket_name" {
  description = "The name of the storage bucket which will be used to hold application state information."
  type        = string
}

variable "storage_bucket_project" {
  description = "The ID of the project which hosts the storage bucket."
  type        = string
}

variable "tbw_image" {
  default     = null
  description = "A selector which determines if the Terraform Build Workers are provisioned from the default Docker image or a custom Docker image. The valid values are: default_image; custom_image."
  type        = string
}

variable "tls_vers" {
  default     = null
  description = "The versions of TLS to be supported in communication with the application. The valid values are: tls_1_2_tls_1_3; tls_1_2; tls_1_3."
  type        = string
}
