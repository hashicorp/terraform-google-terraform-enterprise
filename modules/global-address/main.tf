resource "google_compute_global_address" "main" {
  name = "${var.prefix}-${var.install_id}"

  description = "The global address of TFE."
}
