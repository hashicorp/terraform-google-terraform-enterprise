resource "google_compute_global_address" "main" {
  name = "${var.prefix}-${var.install_id}"

  project = var.project

  description = "The global address of TFE."
}
