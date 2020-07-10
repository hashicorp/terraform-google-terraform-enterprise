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

output "external_load_balancer_address" {
  value = google_compute_global_address.external_load_balancer

  description = "The IP address to be attached to the external load balancer."
}

output "install_dashboard_tcp_port" {
  value = var.install_dashboard_tcp_port

  description = "The install dashboard TCP port."
}

output "kubernetes_tcp_port" {
  value = var.kubernetes_tcp_port

  description = "The Kubernetes TCP port."
}

output "kubelet_tcp_port" {
  value = var.kubelet_tcp_port

  description = "The Kubelet TCP port."
}

output "postgresql_address" {
  value = google_compute_global_address.postgresql
}

output "network" {
  value = google_compute_network.main

  description = "The network to which resources will be attached."
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
