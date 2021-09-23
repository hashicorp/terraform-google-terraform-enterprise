# GENERAL
# -------
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

variable "namespace" {
  description = "Prefix for naming resources"
  type        = string
}

variable "node_count" {
  description = "Number of TFE nodes. Between 1 and 5"
  type        = number
  validation {
    condition     = var.node_count <= 5
    error_message = "The node_count value must be less than or equal to 5."
  }
}

variable "proxy_ip" {
  default     = null
  description = "IP Address of the proxy server"
  type        = string
}

variable "ca_certificate_secret" {
  default     = null
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded PEM certificate file for a Certificate Authority. The
  Terraform provider calls this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

# NETWORKING 
# -----------
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

variable "networking_subnet_range" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the created subnet"
  type        = string
}

variable "networking_reserve_subnet_range" {
  default     = "10.1.0.0/16"
  description = <<-EOD
  The range of IP addresses to reserve for the subnetwork dedicated to internal HTTPS load balancing, expressed in CIDR
  format.
  EOD
  type        = string
}

variable "networking_ip_allow_list" {
  default     = ["0.0.0.0/0"]
  description = "List of allowed IPs for the firewall"
  type        = list(string)
}

variable "network" {
  default     = null
  description = "Pre-existing network self link"
  type        = string
}

variable "subnetwork" {
  default     = null
  description = "Pre-existing subnetwork self link"
  type        = string
}

variable "load_balancer" {
  default     = "PRIVATE"
  description = "Load Balancing Scheme. Supported values are: \"PRIVATE\"; \"PRIVATE_TCP\"; \"PUBLIC\"."
  type        = string

  validation {
    condition     = contains(["PRIVATE", "PRIVATE_TCP", "PUBLIC"], var.load_balancer)
    error_message = "The load_balancer value must be one of: \"PRIVATE\"; \"PRIVATE_TCP\"; \"PUBLIC\"."
  }
}

variable "ssh_source_ranges" {
  default     = ["35.235.240.0/20"]
  description = "The source IP address ranges from which SSH traffic will be permitted; these ranges must be expressed in CIDR notation. The default value permits traffic from GCP's Identity-Aware Proxy."
  type        = list(string)
}

# DATABASE
# --------
variable "database_name" {
  default     = "tfe"
  description = "Postgres database name"
  type        = string
}

variable "database_user" {
  default     = "tfe_user"
  description = "Postgres username"
  type        = string
}

variable "database_machine_type" {
  default     = "db-custom-4-16384"
  description = "Database machine type"
  type        = string
}

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

variable "postgres_disk_size" {
  default     = 50
  description = "The size of the SQL database instance data disk, expressed in gigabytes."
  type        = number
}

variable "postgres_version" {
  default     = "POSTGRES_9_6"
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

# VM
# --
variable "vm_machine_type" {
  default     = "n1-standard-4"
  description = "VM Machine Type"
  type        = string
}

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

variable "vm_auto_healing_enabled" {
  default     = false
  description = "Auto healing for the instance group"
  type        = bool
}

# USER DATA / TFE
# ---------------
variable "release_sequence" {
  default     = 0
  description = "Release sequence of Terraform Enterprise to install."
  type        = number
}

variable "airgap_url" {
  default     = null
  description = "The URL of the storage bucket object that comprises an airgap package."
  type        = string
}

variable "ca_certs" {
  default     = null
  description = <<-EOD
  A custom Certificate Authority certificate bundle to be used for authenticating connections with Terraform Enterprise.
  EOD
  type        = string
}

variable "capacity_concurrency" {
  default     = "10"
  description = "The maximum number of Terraform runs that will be executed concurrently on each compute instance."
  type        = string
}

variable "capacity_memory" {
  default     = "512"
  description = <<-EOD
  The maximum amount of memory that will be allocated to each Terraform run. The value must be expressed in megabytes.
  EOD
  type        = string
}

variable "custom_image_tag" {
  default     = "hashicorp/build-worker:now"
  description = "The tag of the Docker image to be used as the custom Terraform Build Worker image."
  type        = string
}

variable "extra_no_proxy" {
  default     = []
  description = "A list of hosts for which Terraform Enterprise will not use a proxy to access."
  type        = list(string)
}

variable "disk_path" {
  default     = "/opt/hashicorp/data"
  description = "The pathname of the directory in which Terraform Enterprise will store data on the compute instances."
  type        = string
}

variable "enable_metrics_collection" {
  default     = "1"
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

variable "hairpin_addressing" {
  default     = false
  description = "A toggle to control the use of hairpin addressing within the TFE deployment."
  type        = bool
}

variable "fqdn" {
  description = "Fully qualified domain name for the TFE endpoint"
  type        = string
}

variable "license_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded Replicated license file. The Terraform provider calls
  this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "monitoring_enabled" {
  default     = false
  description = "A toggle which controls the use of Stackdriver monitoring on the compute instances."
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

variable "redis_use_tls" {
  default     = false
  description = "A toggle to control the use of TLS when connecting to the Redis endpoint."
  type        = bool
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

variable "tbw_image" {
  default     = "default_image"
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
