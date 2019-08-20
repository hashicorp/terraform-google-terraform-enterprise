module "lb" {
  source            = "./modules/lb"
  domain            = "${var.domain}"
  publicIP          = "${var.public_ip}"
  cert              = "${var.certificate}"
  sslpolicy         = "${var.ssl_policy}"
  primary_instances = "${google_compute_instance.primary.*.self_link}"
  instance_group    = "${google_compute_instance_group.primaries.self_link}"
  frontenddns       = "${var.frontend_dns}"
}
