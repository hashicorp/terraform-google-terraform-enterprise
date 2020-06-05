variable "application_tcp_port" {
  default     = "443"
  description = "The Application TCP port. The value must be supported for HTTPS load balancing. More information is available at https://cloud.google.com/load-balancing/docs/https."
  type        = string
}

variable "cluster_assistant_tcp_port" {
  default     = "23010"
  description = "The Cluster Assistant TCP port."
}

variable "etcd_tcp_port_ranges" {
  default     = ["2379", "2380", "4001", "7001"]
  description = "The etcd TCP port ranges."
  type        = list(string)
}

variable "health_check_ip_cidr_ranges" {
  default     = ["35.191.0.0/16", "130.211.0.0/22"]
  description = "A list of GCP health check IP address ranges from which health check traffic will be authorized to flow. The values must be expressed in CIDR notation. The default values were obtained from the GCP Health Checks Overview article: https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges."
  type        = list(string)
}

variable "install_dashboard_tcp_port" {
  default     = "8085"
  description = "The install dashboard TCP port. The value must be supported for TCP load balancing. More information is available at https://cloud.google.com/load-balancing/docs/tcp."
  type        = string
}

variable "kubernetes_tcp_port" {
  default     = "6443"
  description = "The Kubernetes TCP port."
  type        = string
}

variable "kubelet_tcp_port" {
  default     = "10250"
  description = "The Kubelet TCP port."
  type        = string
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "internal_load_balancer_subnetwork_ip_cidr_range" {
  default     = "10.2.0.0/23"
  description = "The range of IP addresses to provision in the internal load balancer subnetwork. The value must be expressed in CIDR notation. The default value was obtained from the GCP Proxy Only Subnets article: https://cloud.google.com/load-balancing/docs/l7-internal/proxy-only-subnets#proxy_only_subnet_create"
  type        = string
}

variable "replicated_tcp_port_ranges" {
  default     = ["9870-9881"]
  description = "The Replicated TCP port ranges."
  type        = list(string)
}

variable "ssh_tcp_port" {
  default     = "22"
  description = "The SSH TCP port."
  type        = string
}

variable "subnetwork_ip_cidr_range" {
  default     = "10.1.0.0/16"
  description = "The range of IP addresses to provision in the subnetwork. The value must be expressed in CIDR notation."
  type        = string
}

variable "service_account_primaries_email" {
  type        = string
  description = "The email address of the service account associated with the primaries."
}

variable "service_account_primaries_load_balancer_email" {
  type        = string
  description = "The email address of the service account associated with the primaries load balancer."
}

variable "service_account_secondaries_email" {
  type        = string
  description = "The email address of the service account associated with the secondaries."
}

variable "weave_tcp_port" {
  default     = "6783"
  description = "The Weave ports."
  type        = string
}

variable "weave_udp_port_ranges" {
  default     = ["6783", "6784"]
  description = "The Weave UDP port ranges."
  type        = list(string)
}
