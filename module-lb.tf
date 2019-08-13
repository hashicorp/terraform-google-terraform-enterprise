module "lb" {
  source   = "./modules/lb"
  domain   = "${var.domain}"
  publicIP = "${var.publicip}"
  cert     = "${var.cert}"
  sslpolicy = "${var.sslpolicy}"
  primary_instances = "${google_compute_instance.primary.*.self_link}"
  instance_group = "${google_compute_instance_group.primaries.self_link}"
  frontenddns = "${var.frontenddns}"
}
