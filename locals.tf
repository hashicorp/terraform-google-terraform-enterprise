locals {
  install_id           = var.install_id != "" ? var.install_id : random_string.install_id.result
  rendered_dns_project = var.dns_project != "" ? var.dns_project : var.project
}
