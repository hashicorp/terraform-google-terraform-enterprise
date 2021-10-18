locals {
  standalone_named_ports = toset(
    [
      {
        name = "https"
        port = 443
      },
      {
        name = "console"
        port = 8800
      }
    ]
  )
  active_active_named_ports = toset(
    [
      {
        name = "https"
        port = 443
      },
    ]
  )
  named_ports = var.active_active ? local.active_active_named_ports : local.standalone_named_ports
  zones = slice(data.google_compute_zones.up.names, 0, 2)
}
