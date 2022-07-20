locals {
  repository_location = "us-west1"
  repository_name     = "terraform-build-worker"
  ssh_user            = "ubuntu"
  enable_ssh_config = length(var.license_file) > 0 ? 1 : 0
}
