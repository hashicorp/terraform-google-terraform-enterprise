module "internal_lb" {
  source     = "./modules/internal_lb"
  install_id = var.install_id
  prefix     = var.prefix
  region     = var.region

  subnet    = var.subnet
  vpc_name  = var.vpc_name
  primaries = google_compute_instance_group.primaries.self_link
}
