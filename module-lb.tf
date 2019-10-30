module "lb" {
  source         = "./modules/lb"
  domain         = "${var.domain}"
  publicIP       = "${var.public_ip}"
  cert           = "${var.certificate}"
  sslpolicy      = "${var.ssl_policy}"
  instance_group = "${google_compute_instance_group.primaries.self_link}"
  frontenddns    = "${var.frontend_dns}"
  prefix         = "${var.prefix}"
}
