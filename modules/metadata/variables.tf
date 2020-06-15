variable "airgap_package_url" {
  default     = ""
  description = "The URL of an airgap package which contains a TFE release."
  type        = string
}

variable "airgap_installer_url" {
  default     = "https://install.terraform.io/installer/replicated-v5.tar.gz"
  description = "The URL of an airgap package which contains the cluster installer."
  type        = string
}

variable "ca_certs_url" {
  default     = ""
  description = "The URL of a certificate authority bundle which contains custom certificates to be trusted by the application."
  type        = string
}

variable "capacity_memory" {
  default     = ""
  description = "The amount of memory to allocate for each Terraform run, expressed in units of megabytes."
  type        = string
}

variable "custom_image_name" {
  default     = ""
  description = "The name of a custom Docker image which will be used to provision Terraform Build Workers. var.tbw_image must be set to 'custom_image' in order for this variable to be used."
  type        = string
}

variable "dns_fqdn" {
  description = "The routable hostname of the application endpoint."
  type        = string
}

variable "enc_password" {
  default     = ""
  description = "The password which will be used to encrypt sensitive data at rest."
  type        = string
}

variable "extern_vault_addr" {
  default     = ""
  description = "The URL of the external Vault cluster. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "extern_vault_enable" {
  default     = "0"
  description = "Toggle the use of an external Vault deployment."
  type        = string
}

variable "extern_vault_path" {
  default     = ""
  description = "The path to the AppRole auth method on the external Vault cluster. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "extern_vault_role_id" {
  default     = ""
  description = "The RoleID of the AppRole to be used for authentication with the external Vault cluster. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "extern_vault_secret_id" {
  default     = ""
  description = "The SecretID of the AppRole to be used for authentication with the external Vault cluster. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "extern_vault_token_renew" {
  default     = ""
  description = "The period of time between renewals of the external Vault cluster token, expressed in units of seconds. var.extern_vault_addr must be set in order for this variable to be used."
  type        = string
}

variable "http_proxy" {
  default     = ""
  description = "The URL of a proxy through which application traffic will be routed."
  type        = string
}

variable "iact_subnet_list" {
  default     = []
  description = "A list of IP address ranges from which access to the Initial Admin Creation Token API will be authorized, expressed in CIDR notation."
  type        = list(string)
}

variable "iact_subnet_time_limit" {
  default     = ""
  description = "The amount of time to allow for access to the Initial Admin Creation Token API from var.iact_subnet_list, expressed in units of minutes. A value of 'unlimited' will disable the limit."
  type        = string
}

variable "ip_alloc_range" {
  default     = ""
  description = "A custom IP address range over which Weave will communicate. The value must be expressed in CIDR notation."
  type        = string
}

variable "license_url" {
  description = "The URL of a Replicated license file for the application."
  type        = string
}

variable "no_proxy" {
  default     = []
  description = "A list of hostnames to which traffic from the application will not be proxied."
  type        = list(string)
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

variable "ptfe_url" {
  default     = "https://install.terraform.io/installer/ptfe-0.1.zip"
  description = "The URL of the cluster installer tool."
  type        = string
}

variable "release_sequence" {
  default     = ""
  description = "The sequence identifier of the TFE version to which the cluster will be pinned."
  type        = string
}

variable "service_account_storage_key_private_key" {
  description = "The private key of the service account which is authorized to manage the storage bucket, expressed in Base64 encoding."
  type        = string
}

variable "service_cidr" {
  default     = ""
  description = "A custom IP address range over which Replicated will communicate. The value must be expressed in CIDR notation."
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
  default     = ""
  description = "A selector which determines if the Terraform Build Workers are provisioned from the default Docker image or a custom Docker image. The valid values are: default_image; custom_image."
  type        = string
}

variable "tls_vers" {
  default     = ""
  description = "The versions of TLS to be supported in communication with the application. The valid values are: tls_1_2_tls_1_3; tls_1_2; tls_1_3."
  type        = string
}

variable "vpc_cluster_assistant_tcp_port" {
  description = "The Cluster Assistant TCP port."
  type        = string
}

variable "vpc_install_dashboard_tcp_port" {
  description = "The install dashboard TCP port."
  type        = string
}

variable "vpc_kubernetes_tcp_port" {
  description = "The Kubernetes TCP port."
  type        = string
}

variable "vpc_primaries_load_balancer_address" {
  description = "The IP address of the primaries load balancer."
  type        = string
}
