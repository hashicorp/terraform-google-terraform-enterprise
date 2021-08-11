
variable "dns_create_record" {
  default     = true
  description = "If true, will create a DNS record. If false, no record will be created and IP of load balancer will instead be output"
  type        = bool
}
variable "dns_zone_name" {
  default     = ""
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
  default     = ""
  description = "IP Address of the proxy server"
  type        = string
}
variable "proxy_cert_name" {
  default     = "proxy-cert"
  description = "Name for the stored proxy certificate bundle"
  type        = string
}
variable "proxy_cert_path" {
  default     = ""
  description = "Local path to the proxy certificate bundle"
  type        = string
}
# NETWORKING VARS
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
  default     = ""
  description = "Pre-existing network self link"
  type        = string
}
variable "subnetwork" {
  default     = ""
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
# DATABASE VARS
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
# REDIS VARS
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
# REPLICATED VARS
variable "release_sequence" {
  default     = 0
  description = "Release sequence of Terraform Enterprise to install."
  type        = number
}
# VM VARS
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
# TFE VARS
variable "license_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded Replicated license file. The Terraform provider calls
  this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}
variable "fqdn" {
  description = "Fully qualified domain name for the TFE endpoint"
  type        = string
}
variable "ssl_certificate_name" {
  description = "Name of the created managed SSL certificate. Required when load_balancer == \"PUBLIC\" or load_balancer == \"PRIVATE\"."
  type        = string
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

variable "trusted_proxies" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be considered safe to ignore when evaluating the IP addresses of requests like
  those made to the IACT endpoint.
  EOD
  type        = list(string)
}
