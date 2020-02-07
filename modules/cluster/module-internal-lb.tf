module "internal_lb" {
  source     = "./../internal_lb"
  install_id = var.install_id
  prefix     = var.prefix
  region     = var.region

  subnet    = var.subnet
  primaries = google_compute_instance_group.primaries.self_link
}
