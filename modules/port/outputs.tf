output "application_tcp" {
  value = "443"

  description = "The Application TCP port."
}

output "cluster_assistant_tcp" {
  value = "23010"

  description = "The Cluster Assistant TCP port."
}

output "etcd_tcp_ranges" {
  value = ["2379", "2380", "4001", "7001"]

  description = "The etcd TCP port ranges."
}

output "kubernetes_tcp" {
  value = "6443"

  description = "The Kubernetes TCP port."
}

output "kubelet_tcp" {
  value = "10250"

  description = "The Kubelet TCP port."
}

output "replicated_tcp_ranges" {
  value = ["9870-9881"]

  description = "The Replicated TCP port ranges."
}

output "replicated_ui_tcp" {
  value = "8800"

  description = "The Replicated UI TCP port."
}

output "ssh_tcp" {
  value = "22"

  description = "The SSH TCP port."
}

output "weave_tcp" {
  value = "6783"

  description = "The Weave ports."
}

output "weave_udp_ranges" {
  value = ["6783", "6784"]

  description = "The Weave UDP port ranges."
}
