resource "google_service_account" "storage" {
  account_id = "${var.prefix}storage"

  description  = "The identity which will be used to access the TFE storage bucket."
  display_name = "TFE Storage"
}

resource "google_service_account_key" "storage" {
  service_account_id = google_service_account.storage.name
}

resource "google_service_account" "primaries" {
  account_id = "${var.prefix}primaries"

  display_name = "TFE Primaries"
  description  = "The identity to be associated with the TFE primaries."
}

resource "google_service_account" "secondaries" {
  account_id = "${var.prefix}secondaries"

  display_name = "TFE Secondaries"
  description  = "The identity to be associated with the TFE secondaries."
}

resource "google_service_account" "internal_load_balancer" {
  account_id = "${var.prefix}ilb"

  description  = "The identity to be associated with the TFE internal load balancer."
  display_name = "TFE Internal Load Balancer"
}
