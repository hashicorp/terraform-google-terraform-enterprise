output "application_tcp_port" {
  value = var.application_tcp_port

  description = "The application TCP port."
}

output "cluster_assistant_tcp_port" {
  value = var.cluster_assistant_tcp_port

  description = "The Cluster Assistant TCP port."
}

output "etcd_tcp_port_ranges" {
  value = var.etcd_tcp_port_ranges

  description = "The etcd TCP port ranges."
}

output "internal_load_balancer_subnetwork" {
  value = google_compute_subnetwork.internal_load_balancer

  description = "The subnetwork reserved for internal load balancing."
}

output "external_load_balancer_address" {
  value = google_compute_global_address.external_load_balancer

  description = "The IP address to be attached to the external load balancer."
}

output "install_dashboard_tcp_port" {
  value = var.install_dashboard_tcp_port

  description = "The install dashboard TCP port."
}

output "internal_load_balancer_address" {
  value = google_compute_address.internal_load_balancer

  description = "The IP address to be attached to the internal load balancer."
}

output "kubernetes_tcp_port" {
  value = var.kubernetes_tcp_port

  description = "The Kubernetes TCP port."
}

output "kubelet_tcp_port" {
  value = var.kubelet_tcp_port

  description = "The Kubelet TCP port."
}

output "network" {
  value = google_compute_network.main

  description = "The network to which resources will be attached."
}

output "postgresql_address" {
  value = google_compute_global_address.postgresql

  description = "The internal IP address to be attached to the PostgreSQL database compute instance."
}

output "primaries_address" {
  value = google_compute_address.primaries

  description = "The internal IP address to be attached to the primaries compute instance group."
}

output "primaries_load_balancer_address" {
  value = google_compute_address.primaries_load_balancer

  description = "The internal IP address to be attached to the primaries load balancer."
}

output "replicated_tcp_port_ranges" {
  value = var.replicated_tcp_port_ranges

  description = "The Replicated TCP port ranges."
}

output "ssh_tcp_port" {
  value = var.ssh_tcp_port

  description = "The SSH TCP port."
}

output "subnetwork" {
  value = google_compute_subnetwork.main

  description = "The subnetwork to which resources will be attached."
}

output "weave_tcp_port" {
  value = var.weave_tcp_port

  description = "The Weave ports."
}

output "weave_udp_port_ranges" {
  value = var.weave_udp_port_ranges

  description = "The Weave UDP port ranges."
}
