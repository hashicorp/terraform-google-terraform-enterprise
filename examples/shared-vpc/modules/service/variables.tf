variable "cloud_init_license_file" {
  description = "The pathname of a Replicated license file for the application."
  type        = string
}

variable "dns_managed_zone" {
  description = "The name of the managed DNS zone in which the application will be accessible."
  type        = string
}

variable "dns_managed_zone_dns_name" {
  description = "The fully qualified DNS name of the managed zone set by var.dns_managed_zone."
  type        = string
}

variable "labels" {
  default     = {}
  description = "A collection of labels which will be applied to resources."
  type        = map(string)
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "service_account_internal_load_balancer_email" {
  description = "The email address of the service account which will be associated with the internal load balancer."
  type        = string
}

variable "service_account_primaries_email" {
  description = "The email address of the service account which will be associated with the primaries."
  type        = string
}

variable "service_account_secondaries_email" {
  description = "The email address of the service account which will be associated with the secondaries."
  type        = string
}

variable "service_account_storage_email" {
  type        = string
  description = "The email address of the service account which will be authorized to access the storage bucket."
}

variable "service_account_storage_key_private_key" {
  description = "The private key of the service account which is authorized to manage the storage bucket, expressed in Base64 encoding."
  type        = string
}

variable "vpc_application_tcp_port" {
  description = "The Application TCP port."
  type        = string
}

variable "vpc_cluster_assistant_tcp_port" {
  description = "The Cluster Assistant TCP port."
}

variable "vpc_etcd_tcp_port_ranges" {
  description = "The etcd TCP port ranges."
  type        = list(string)
}

variable "vpc_external_load_balancer_address" {
  type = string
}

variable "vpc_kubernetes_tcp_port" {
  description = "The Kubernetes TCP port."
  type        = string
}

variable "vpc_kubelet_tcp_port" {
  description = "The Kubelet TCP port."
  type        = string
}

variable "vpc_network_self_link" {
  description = "The self link of the network to which resources will be attached."
  type        = string
}

variable "vpc_postgresql_address_name" {
  type = string
}

variable "vpc_replicated_tcp_port_ranges" {
  description = "The Replicated TCP port ranges."
  type        = list(string)
}

variable "vpc_replicated_ui_tcp_port" {
  description = "The Replicated UI TCP port."
  type        = string
}

variable "vpc_ssh_tcp_port" {
  description = "The SSH TCP port."
  type        = string
}

variable "vpc_subnetwork_ip_cidr_range" {
  description = "The range from which IP addresses will be assigned to resources, expressed in CIDR notation. The range must be part of var.vpc_subnetwork_self_link."
  type        = string
}

variable "vpc_subnetwork_name" {
  description = "The name of the shared VPC subnetwork to which resources will be attached."
  type        = string
}

variable "vpc_subnetwork_project" {
  description = "The ID of the project in which var.vpc_subnetwork_name exists."
  type        = string
}

variable "vpc_subnetwork_region" {
  description = "The region in which var.vpc_subnetwork_name exists."
  type        = string
}

variable "vpc_subnetwork_self_link" {
  description = "The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc_network_self_link."
  type        = string
}

variable "vpc_weave_tcp_port" {
  description = "The Weave ports."
  type        = string
}

variable "vpc_weave_udp_port_ranges" {
  description = "The Weave UDP port ranges."
  type        = list(string)
}
