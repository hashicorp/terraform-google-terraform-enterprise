locals {
  standalone_ports    = ["80", "443", "8800"]
  active_active_ports = ["80", "443"]
  ports               = var.active_active ? local.active_active_ports : local.standalone_ports
}
