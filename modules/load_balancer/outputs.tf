# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "compute_backend_url_map_self_link" {
  value = google_compute_url_map.lb.self_link
}

