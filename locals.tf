locals {
  install_id           = var.install_id != "" ? var.install_id : random_string.install_id.result
}
