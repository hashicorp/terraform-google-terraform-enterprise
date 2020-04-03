output "console_url" {
  # This conditional logic prevents an invalid index error when the value is evaluated after
  # google_compute_instance.primary is destroyed. An example of this scenario is when a destroy process is resumed
  # after recovering from an error.
  value = length(google_compute_instance.main) > 0 ? (
    "https://${google_compute_instance.main[0].network_interface[0].access_config[0].nat_ip}:${var.vpc_replicated_ui_tcp_port}"
  ) : ""

  description = "The URL of the management console."
}

output "instances" {
  value = google_compute_instance.main

  description = "The compute instances which comprise the cluster."
}

output "instance_group" {
  value = google_compute_instance_group.main

  description = "The compute instance group for the cluster."
}
