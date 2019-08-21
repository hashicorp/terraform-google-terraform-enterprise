module "instance-template" {
  source                 = "./modules/instance-template"
  region                 = "${var.region}"
  secondary_machine_type = "${local.rendered_secondary_machine_type}"

  ptfe_subnet            = "${var.subnet}"
  cluster_endpoint       = "${var.primary_hostname}-0"
  bootstrap_token_id     = "${random_string.bootstrap_token_id.result}"
  bootstrap_token_suffix = "${random_string.bootstrap_token_suffix.result}"
  setup_token            = "${random_string.setup_token.result}"
  image_family           = "${var.image_family}"
  install_type           = "${var.install_type}"
  repl_data              = "${base64encode("${random_pet.console_password.id}")}"
  release_sequence       = "${var.release_sequence}"
  boot_disk_size         = "${var.boot_disk_size}"
}
