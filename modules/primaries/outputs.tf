output "instances" {
  value = google_compute_instance.main

  description = "The compute instances which comprise the cluster."
}

output "instance_group" {
  value = google_compute_instance_group.main

  description = "The compute instance group for the cluster."
}
