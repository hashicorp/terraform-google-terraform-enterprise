variable "health_check_ip_cidr_ranges" {
  default     = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22", "130.211.0.0/22"]
  description = "The list of GCP health check IP address ranges from which health check traffic will be authorized to flow, expressed in CIDR notation. The default ranges were obtained from the GCP Health Checks Overview: https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges."
  type        = list(string)
}

variable "vpc_network_self_link" {
  description = "The self link of the network to which resources will be attached."
  type        = string
}

variable "port_application_tcp" {
  description = "The port over which application TCP traffic will travel."
  type        = string
}

variable "port_cluster_assistant_tcp" {
  description = "The port over which Cluster Assistant TCP traffic will travel."
  type        = string
}

variable "port_etcd_tcp_ranges" {
  description = "The port ranges over which etcd TCP traffic will travel."
  type        = list(string)
}

variable "port_kubelet_tcp" {
  description = "The port over which Kubelet TCP traffic will travel."
  type        = string
}

variable "port_kubernetes_tcp" {
  description = "The port over which Kubernetes TCP traffic will travel."
  type        = string
}

variable "port_replicated_tcp_ranges" {
  description = "The port ranges over which Replicated TCP traffic will travel."
  type        = list(string)
}

variable "port_replicated_ui_tcp" {
  description = "The port over which Replicated UI TCP traffic will travel."
  type        = string
}

variable "port_weave_tcp" {
  description = "The port over which Weave TCP traffic will travel."
  type        = string
}

variable "port_weave_udp_ranges" {
  description = "The port ranges over which Weave UDP traffic will travel."
  type        = list(string)
}

variable "port_ssh_tcp" {
  description = "The port over which SSH TCP traffic will travel."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "service_account_primary_cluster_email" {
  type        = string
  description = "The email address of the service account associated with the primary cluster."
}

variable "service_account_proxy_email" {
  type        = string
  description = "The email address of the service account associated with the proxy."
}

variable "service_account_secondary_cluster_email" {
  type        = string
  description = "The email address of the service account associated with the secondary cluster."
}

variable "vpc_subnetwork_ip_cidr_range" {
  description = "The range of IP addresses in the subnetwork from which traffic will be authorized to flow, expressed in CIDR notation."
  type        = string
}
