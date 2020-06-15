variable "cpu_utilization_target" {
  default     = 0.7
  description = "The CPU utilization target of the compute instance group which will trigger the creation of an additional instance."
}

variable "disk_image" {
  default     = "tfe-ubuntu-1804-2020-06-12-19-57-01"
  description = "The image from which to initialize the compute instance disks. The supported images are: ubuntu-1604-lts; ubuntu-1804-lts; rhel-7."
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
  description = "The identifier of the set of virtualized hardware resources which will be available to the compute instances."
  type        = string
}

variable "max_instances" {
  default     = 5
  description = "The maximum count of compute instances to scale to based on var.cpu_utilization_target."
  type        = number
}

variable "metadata" {
  description = "The metadata for all of the compute instances."
  type        = map(string)
}

variable "min_instances" {
  default     = 1
  description = "The minimum count of compute instances to scale to based on var.cpu_utilization_target."
  type        = number
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "service_account_email" {
  type        = string
  description = "The email address of the service account which will be associated with the secondaries."
}

variable "vpc_application_tcp_port" {
  description = "The application TCP port."
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

variable "vpc_network_self_link" {
  description = "The self link of the network to which resources will be attached."
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
