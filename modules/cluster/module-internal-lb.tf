module "internal_lb" {
  source     = "./modules/internal_lb"
  install_id = var.install_id
  prefix     = var.prefix
  region     = var.region

  subnet            = var.subnet
  primary_hostnames = google_compute_instance.primary.*.name
}
