locals {
  install_id                        = var.install_id != "" ? var.install_id : random_string.install_id.result
  rendered_dns_project              = var.dns_project != "" ? var.dns_project : var.project
  rendered_secondary_machine_type   = var.secondary_machine_type != "" ? var.secondary_machine_type : var.primary_machine_type
  rendered_secondary_boot_disk_size = var.secondary_boot_disk_size != "" ? var.secondary_boot_disk_size : var.primary_boot_disk_size
}
