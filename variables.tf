# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# GENERAL
# -------
variable "ca_certificate_secret_id" {
  default     = null
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file for a Certificate Authority. The
  Terraform provider calls this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "dns_create_record" {
  default     = true
  description = "If true, will create a DNS record. If false, no record will be created and IP of load balancer will instead be output"
  type        = bool
}

variable "dns_zone_name" {
  default     = null
  description = "Name of the DNS zone set up in GCP"
  type        = string
}

variable "existing_service_account_id" {
  description = <<-EOD
  An ID of an existing service account to use for log management. Setting this value prevents terraform from creating
  a new user and assigning  a logWriter IAM role.
  EOD
  type        = string
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "namespace" {
  description = "Prefix for naming resources"
  type        = string
}

variable "node_count" {
  description = <<-EOD
  The number of Terraform Enterprise nodes to deploy. Setting this value greater than 1 will enable Active/Active,
  forcing the Production installation type and the External production type.
  EOD
  type        = number
  validation {
    condition     = var.node_count >= 0 && var.node_count <= 5
    error_message = "The node_count value must be between 0 and 2, inclusively."
  }
}

variable "proxy_ip" {
  default     = null
  description = <<-EOD
  The host subcomponent of an HTTP proxy URI authority. This value will be used
  to configure the HTTP and HTTPS proxy settings of the operating system and Terraform Enterprise.
  EOD
  type        = string
}

variable "proxy_port" {
  default     = null
  description = <<-EOD
  The port subcomponent of an HTTP proxy URI authority. This value will be used
  to configure the HTTP and HTTPS proxy settings of the operating system and Terraform Enterprise.
  EOD
  type        = string
}


# NETWORKING
# -----------
variable "load_balancer" {
  default     = "PRIVATE"
  description = "Load Balancing Scheme. Supported values are: \"PRIVATE\"; \"PRIVATE_TCP\"; \"PUBLIC\"."
  type        = string

  validation {
    condition     = contains(["PRIVATE", "PRIVATE_TCP", "PUBLIC"], var.load_balancer)
    error_message = "The load_balancer value must be one of: \"PRIVATE\"; \"PRIVATE_TCP\"; \"PUBLIC\"."
  }
}


variable "network" {
  default     = null
  description = "Pre-existing network self link"
  type        = string
}
variable "networking_firewall_ports" {
  default     = []
  description = "Additional ports to open in the firewall"
  type        = list(string)
}

variable "networking_healthcheck_ips" {
  default     = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
  description = "Allowed IPs required for healthcheck. Provided by GCP"
  type        = list(string)
}

variable "networking_ip_allow_list" {
  default     = ["0.0.0.0/0"]
  description = "List of allowed IPs for the firewall"
  type        = list(string)
}

variable "networking_reserve_subnet_range" {
  default     = "10.2.0.0/16"
  description = <<-EOD
  The range of IP addresses to reserve for the subnetwork dedicated to internal HTTPS load balancing, expressed in CIDR
  format.
  EOD
  type        = string
}

variable "networking_subnet_range" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the created subnet"
  type        = string
}

variable "ssh_source_ranges" {
  default     = ["35.235.240.0/20"]
  description = "The source IP address ranges from which SSH traffic will be permitted; these ranges must be expressed in CIDR notation. The default value permits traffic from GCP's Identity-Aware Proxy."
  type        = list(string)
}

variable "subnetwork" {
  default     = null
  description = "Pre-existing subnetwork self link"
  type        = string
}

# DATABASE
# --------
variable "database_availability_type" {
  default     = "ZONAL"
  description = "Database Availability Type"
  type        = string
}

variable "database_backup_start_time" {
  default     = "00:00"
  description = "Database backup start time"
  type        = string
}

variable "database_name" {
  default     = "tfe"
  description = "Postgres database name"
  type        = string
}

variable "database_machine_type" {
  default     = "db-custom-4-16384"
  description = "Database machine type"
  type        = string
}

variable "database_user" {
  default     = "tfe_user"
  description = "Postgres username"
  type        = string
}

variable "postgres_disk_size" {
  default     = 50
  description = "The size of the SQL database instance data disk, expressed in gigabytes."
  type        = number
}

variable "postgres_version" {
  default     = "POSTGRES_12"
  description = "The version of PostgreSQL to be installed on the SQL database instance."
  type        = string
}

# REDIS
# -----
variable "redis_auth_enabled" {
  default     = true
  description = "A toggle to enable Redis authentication"
  type        = bool
}

variable "redis_memory_size" {
  default     = 6
  description = "Redis memory size in GiB"
  type        = number
}

variable "redis_version" {
  type        = string
  description = "The version of Redis to install"
  default     = "REDIS_7_0"
}

# VM
# --
variable "vm_disk_size" {
  default     = 50
  description = "VM Disk size. Should be at least 50"
  type        = number
}

variable "vm_disk_source_image" {
  default     = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
  description = "VM Disk source image"
  type        = string
}

variable "vm_disk_type" {
  default     = "pd-ssd"
  description = "VM Disk type. SSD recommended"
  type        = string
}

variable "vm_machine_type" {
  default     = "n1-standard-4"
  description = "VM Machine Type"
  type        = string
}

variable "vm_metadata" {
  default     = {}
  description = "Metadata key/value pairs to make available from within the compute instances."
  type        = map(string)
}

variable "vm_mig_check_interval_sec" {
  default     = 60
  description = "How often (in seconds) to send a health check."
  type        = number
  validation {
    condition     = var.vm_mig_check_interval_sec >= 1 && var.vm_mig_check_interval_sec <= 300
    error_message = "The vm_mig_check_interval_sec must be an integer between 1 and 300, inclusive."
  }
}

variable "vm_mig_healthy_threshold" {
  default     = 2
  description = "The number of sequential successful health check probe results for a backend to be considered healthy."
  type        = number
  validation {
    condition     = var.vm_mig_healthy_threshold >= 1 && var.vm_mig_healthy_threshold <= 10
    error_message = "The vm_mig_healthy_threshold must be an integer between 1 and 10, inclusive."
  }
}

variable "vm_mig_initial_delay_sec" {
  default     = 600
  description = "The number of seconds that the managed instance group waits before it applies autohealing policies to new instances or recently recreated instances."
  type        = number
  validation {
    condition     = var.vm_mig_initial_delay_sec >= 1 && var.vm_mig_initial_delay_sec <= 3600
    error_message = "The vm_mig_initial_delay_sec must be an integer between 1 and 3600, inclusive."
  }
}

variable "vm_mig_timeout_sec" {
  default     = 10
  description = "How long to wait (in seconds) before a request is considered a failure."
  type        = number
  validation {
    condition     = var.vm_mig_timeout_sec >= 1 && var.vm_mig_timeout_sec <= 300
    error_message = "The vm_mig_timeout_sec must be an integer between 1 and 300 and must be lower than or equal to vm_mig_check_interval_sec."
  }
}

variable "vm_mig_unhealthy_threshold" {
  default     = 6
  description = "The number of sequential failed health check probe results for a backend to be considered unhealthy."
  type        = number
  validation {
    condition     = var.vm_mig_unhealthy_threshold >= 1 && var.vm_mig_unhealthy_threshold <= 10
    error_message = "The vm_mig_unhealthy_threshold must be an integer between 1 and 10, inclusive."
  }
}

variable "vm_mounted_disk_size" {
  default     = 40
  description = <<-EOD
  The size in gigabytes of the mounted disk to attach to the VM when the Operational Mode is Mounted Disk.
  EOD
  type        = number
}

# USER DATA / TFE
# ---------------
variable "airgap_url" {
  default     = null
  description = "The URL of a Replicated airgap package for Terraform Enterprise."
  type        = string
}

variable "bypass_preflight_checks" {
  default     = false
  type        = bool
  description = "Allow the TFE application to start without preflight checks."
}

variable "capacity_concurrency" {
  default     = "10"
  description = "The maximum number of Terraform runs that will be executed concurrently on each compute instance."
  type        = string
}

variable "capacity_memory" {
  default     = null
  type        = number
  description = <<-EOD
  The maximum amount of memory (in megabytes) that a Terraform plan or apply can use on the system;
  defaults to 512.
  EOD
}

variable "consolidated_services_enabled" {
  default     = true
  type        = bool
  description = "(Required) True if TFE uses consolidated services."
}

variable "custom_agent_image_tag" {
  default     = null
  type        = string
  description = <<-EOD
  Configure the docker image for handling job execution within TFE. This can either be the
  standard image that ships with TFE or a custom image that includes extra tools not present
  in the default one. Should be in the format <name>:<tag>.
  EOD
}

variable "custom_image_tag" {
  default     = null
  type        = string
  description = <<-EOD
  The name and tag for your alternative Terraform build worker image in the format <name>:<tag>.
  Default is 'hashicorp/build-worker:now'.
  EOD
}

variable "disk_path" {
  default     = null
  description = "The pathname of the directory in which Terraform Enterprise will store data on the compute instances."
  type        = string
}

variable "distribution" {
  type        = string
  description = "(Required) What is the OS distribution of the instance on which Terraoform Enterprise will be deployed?"
  validation {
    condition     = contains(["rhel", "ubuntu"], var.distribution)
    error_message = "Supported values for distribution are 'rhel' or 'ubuntu'."
  }
}

variable "enable_monitoring" {
  default     = false
  description = "A toggle which controls the use of Stackdriver monitoring on the compute instances."
  type        = bool
}

variable "fqdn" {
  description = "Fully qualified domain name for the TFE endpoint"
  type        = string
}

variable "hairpin_addressing" {
  default     = false
  description = "A toggle to control the use of hairpin addressing within the TFE deployment."
  type        = bool
}

variable "iact_subnet_list" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}

variable "iact_subnet_time_limit" {
  default     = 60
  description = <<-EOD
  The time limit for IP addresses from iact_subnet_list to access the IACT. The value must be expressed in minutes.
  EOD
  type        = number
}

variable "metrics_endpoint_enabled" {
  default     = null
  type        = bool
  description = <<-EOD
  (Optional) Metrics are used to understand the behavior of Terraform Enterprise and to
  troubleshoot and tune performance. Enable an endpoint to expose container metrics.
  Defaults to false.
  EOD
}

variable "metrics_endpoint_port_http" {
  default     = null
  type        = number
  description = <<-EOD
  (Optional when metrics_endpoint_enabled is true.) Defines the TCP port on which HTTP metrics
  requests will be handled.
  Defaults to 9090.
  EOD
}

variable "metrics_endpoint_port_https" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional when metrics_endpoint_enabled is true.) Defines the TCP port on which HTTPS metrics
  requests will be handled.
  Defaults to 9091.
  EOD
}

variable "operational_mode" {
  default     = "external"
  description = <<-EOD
  A special string to control the operational mode of Terraform Enterprise. Valid values are: "external" for External
  Services mode; "disk" for Mounted Disk mode;.
  EOD
  type        = string

  validation {
    condition     = contains(["external", "disk"], var.operational_mode)
    error_message = "The operational_mode value must be one of: \"external\"; \"disk\";."
  }
}

variable "redis_use_tls" {
  default     = false
  description = "A toggle to control the use of TLS when connecting to the Redis endpoint."
  type        = bool
}

variable "release_sequence" {
  default     = null
  description = "Release sequence of Terraform Enterprise to install."
  type        = number
}

variable "ssl_certificate_name" {
  default     = null
  description = "Name of the created managed SSL certificate. Required when load_balancer == \"PUBLIC\" or load_balancer == \"PRIVATE\"."
  type        = string
}

variable "ssl_certificate_secret" {
  default     = null
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file. The Terraform provider calls this
  value the secret_id and the GCP UI calls it the name. This value is only used when load_balancer == "PRIVATE_TCP".
  EOD
  type        = string
}

variable "ssl_private_key_secret" {
  default     = null
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM private key file. The Terraform provider calls this
  value the secret_id and the GCP UI calls it the name. This value is only used when load_balancer == "PRIVATE_TCP".
  EOD
  type        = string
}

variable "tfe_license_bootstrap_airgap_package_path" {
  default     = null
  type        = string
  description = <<-EOD
  (Required if air-gapped installation) The URL of a Replicated airgap package for Terraform
  Enterprise. The suggested path is "/var/lib/ptfe/ptfe.airgap".
  EOD
}

variable "tfe_license_file_location" {
  default     = "/etc/terraform-enterprise.rli"
  type        = string
  description = "The path on the TFE instance to put the TFE license."
}

variable "tfe_license_secret_id" {
  default     = null
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded Replicated license file. The Terraform provider calls
  this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "tls_bootstrap_cert_pathname" {
  default     = null
  type        = string
  description = "The path on the TFE instance to put the certificate. ex. '/var/lib/terraform-enterprise/certificate.pem'"
}

variable "tls_bootstrap_key_pathname" {
  default     = null
  type        = string
  description = "The path on the TFE instance to put the key. ex. '/var/lib/terraform-enterprise/key.pem'"
}

variable "tls_vers" {
  default     = "tls_1_2_tls_1_3"
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
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be considered safe to ignore when evaluating the IP addresses of requests like
  those made to the IACT endpoint.
  EOD
  type        = list(string)
}

# External Vault
# --------------
variable "extern_vault_addr" {
  default     = null
  type        = string
  description = "(Required if var.extern_vault_enable = true) URL of external Vault cluster."
}

variable "extern_vault_enable" {
  default     = false
  type        = bool
  description = "(Optional) Indicate if an external Vault cluster is being used. Set to 1 if so."
}

variable "extern_vault_namespace" {
  default     = null
  type        = string
  description = "(Optional if var.extern_vault_enable = true) The Vault namespace"
}

variable "extern_vault_path" {
  default     = "auth/approle"
  type        = string
  description = "(Optional if var.extern_vault_enable = true) Path on the Vault server for the AppRole auth. Defaults to auth/approle."
}

variable "extern_vault_role_id" {
  default     = null
  type        = string
  description = "(Required if var.extern_vault_enable = true) AppRole RoleId to use to authenticate with the Vault cluster."
}

variable "extern_vault_secret_id" {
  default     = null
  type        = string
  description = "(Required if var.extern_vault_enable = true) AppRole SecretId to use to authenticate with the Vault cluster."
}

variable "extern_vault_token_renew" {
  default     = 3600
  type        = number
  description = "(Optional if var.extern_vault_enable = true) How often (in seconds) to renew the Vault token."
}

