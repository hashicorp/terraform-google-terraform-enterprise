resource "google_secret_manager_secret" "ca_certificate" {
  count = var.ca_certificate == null ? 0 : 1

  secret_id = var.ca_certificate.id

  replication {
    automatic = true
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "ca_certificate" {
  count = length(google_secret_manager_secret.ca_certificate)

  secret_data = base64encode(var.ca_certificate.data)
  secret      = google_secret_manager_secret.ca_certificate[count.index].secret_id
}

resource "google_secret_manager_secret" "ca_private_key" {
  count = var.ca_private_key == null ? 0 : 1

  secret_id = var.ca_private_key.id

  replication {
    automatic = true
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "ca_private_key" {
  count = length(google_secret_manager_secret.ca_private_key)

  secret_data = base64encode(var.ca_private_key.data)
  secret      = google_secret_manager_secret.ca_private_key[count.index].secret_id
}

resource "google_secret_manager_secret" "license" {
  count = var.license == null ? 0 : 1

  secret_id = var.license.id

  replication {
    automatic = true
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "license" {
  count = length(google_secret_manager_secret.license)

  secret_data = filebase64(var.license.path)
  secret      = google_secret_manager_secret.license[count.index].secret_id
}

resource "google_secret_manager_secret" "ssl_certificate" {
  count = var.ssl_certificate == null ? 0 : 1

  secret_id = var.ssl_certificate.id

  replication {
    automatic = true
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "ssl_certificate" {
  count = length(google_secret_manager_secret.ssl_certificate)

  secret_data = base64encode(var.ssl_certificate.data)
  secret      = google_secret_manager_secret.ssl_certificate[count.index].secret_id
}

resource "google_secret_manager_secret" "ssl_private_key" {
  count = var.ssl_private_key == null ? 0 : 1

  secret_id = var.ssl_private_key.id

  replication {
    automatic = true
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "ssl_private_key" {
  count = length(google_secret_manager_secret.ssl_private_key)

  secret_data = base64encode(var.ssl_private_key.data)
  secret      = google_secret_manager_secret.ssl_private_key[count.index].secret_id
}
