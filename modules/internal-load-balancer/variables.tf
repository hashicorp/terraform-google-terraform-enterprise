variable "disk_image" {
  default     = "ubuntu-1804-lts"
  description = "The image from which the main compute instance disks will be initialized. The supported images are: ubuntu-1604-lts; ubuntu-1804-lts; rhel-7."
  type        = string
}

variable "disk_size" {
  default     = 40
  description = "The size of var.disk_image, expressed in units of gigabytes."
  type        = number
}

variable "labels" {
  default     = {}
  description = "The labels which will be applied to the compute instances."
  type        = map(string)
}

variable "machine_type" {
  default     = "n1-standard-8"
  description = "The identifier of the set of virtualized hardware resources which will be available to the compute instances. More details on machine types can be found at https://cloud.google.com/compute/docs/machine-types"
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "primaries_addresses" {
  description = "The IP addresses of the primaries."
  type        = list(string)
}

variable "service_account_email" {
  type        = string
  description = "The email address of the service account to be associated with the compute instances."
}

variable "ssl_bundle_url" {
  description = "The URL of an SSL certificate and private key bundle to be used for application traffic authentication. The file located at the URL must be in PEM format."
  type        = string
}

variable "vpc_application_tcp_port" {
  description = "The application TCP port."
  type        = string
}

variable "vpc_install_dashboard_tcp_port" {
  description = "The install dashboard TCP port."
  type        = string
}

variable "vpc_subnetwork_self_link" {
  description = "The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc_network_self_link."
  type        = string
}

variable "vpc_subnetwork_project" {
  description = "The ID of the project in which var.vpc_subnetwork_self_link exists."
  type        = string
}
