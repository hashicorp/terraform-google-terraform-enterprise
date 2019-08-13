output "cluster_endpoint" {
  value = "${google_compute_global_forwarding_rule.https.self_link}"
}
