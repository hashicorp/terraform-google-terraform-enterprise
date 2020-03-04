output "application" {
  value = {
    tcp = ["443"]
  }

  description = "The Application ports."
}

output "cluster_assistant" {
  value = {
    tcp = ["23010"]
  }

  description = "The Cluster Assistant ports."
}

output "etcd" {
  value = {
    tcp = ["2379", "2380", "4001", "7001"]
  }

  description = "The etcd ports."
}

output "kubernetes" {
  value = {
    tcp = ["6443"]
  }

  description = "The Kubernetes ports."
}

output "kubelet" {
  value = {
    tcp = ["10250"]
  }

  description = "The Kubelet ports."
}

output "replicated" {
  value = {
    tcp = ["9870-9881"]
  }

  description = "The Replicated ports."
}

output "replicated_ui" {
  value = {
    tcp = ["8800"]
  }

  description = "The Replicated UI ports."
}

output "ssh" {
  value = {
    tcp = ["22"]
  }

  description = "The SSH ports."
}

output "weave" {
  value = {
    tcp = ["6783"]
    udp = ["6783", "6784"]
  }

  description = "The Weave ports."
}
