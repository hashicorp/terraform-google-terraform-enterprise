data "google_compute_image" "rhel" {
  name    = "rhel-7-v20220519"
  project = "rhel-cloud"
}

data "google_compute_image" "ubuntu" {
  name    = "ubuntu-2004-focal-v20220118"
  project = "ubuntu-os-cloud"
}