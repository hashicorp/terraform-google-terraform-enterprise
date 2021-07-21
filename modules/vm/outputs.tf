output "instance_group" {
  value = google_compute_region_instance_group_manager.main.instance_group

  description = "The self link of the regional instance group."
}
