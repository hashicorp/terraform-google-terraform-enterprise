resource "google_compute_global_address" "main" {
  name = "${var.prefix}public"

  description = "The global address of TFE."
}
