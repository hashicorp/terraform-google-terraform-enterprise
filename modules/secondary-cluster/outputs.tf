output "instance_group_manager" {
  value = google_compute_region_instance_group_manager.main

  description = "The regional instance group manager."
}
