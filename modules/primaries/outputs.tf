output "instance_groups" {
  value = google_compute_instance_group.main

  description = "The groups of compute instances which comprise the primaries."
}
