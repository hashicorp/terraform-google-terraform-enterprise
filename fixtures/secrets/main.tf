# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "google_secret_manager_secret" "ca_certificate" {
  count = local.ca_certificate_enabled ? 1 : 0

  secret_id = var.ca_certificate.id

  replication {
    auto {

    }
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "ca_certificate" {
  count = length(google_secret_manager_secret.ca_certificate)

  secret_data = base64encode(var.ca_certificate.data)
  secret      = google_secret_manager_secret.ca_certificate[count.index].id
}

resource "google_secret_manager_secret" "ca_private_key" {
  count = local.ca_private_key_enabled ? 1 : 0

  secret_id = var.ca_private_key.id

  replication {
    auto {

    }
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "ca_private_key" {
  count = length(google_secret_manager_secret.ca_private_key)

  secret_data = base64encode(var.ca_private_key.data)
  secret      = google_secret_manager_secret.ca_private_key[count.index].id
}

resource "google_secret_manager_secret" "license" {
  count = local.license_enabled ? 1 : 0

  secret_id = var.license.id

  replication {
    auto {

    }
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "license" {
  count = length(google_secret_manager_secret.license)

  secret_data = filebase64(var.license.path)
  secret      = google_secret_manager_secret.license[count.index].id
}

resource "google_secret_manager_secret" "ssl_certificate" {
  count = local.ssl_certificate_enabled ? 1 : 0

  secret_id = var.ssl_certificate.id

  replication {
    auto {

    }
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "ssl_certificate" {
  count = length(google_secret_manager_secret.ssl_certificate)

  secret_data = base64encode(var.ssl_certificate.data)
  secret      = google_secret_manager_secret.ssl_certificate[count.index].id
}

resource "google_secret_manager_secret" "ssl_private_key" {
  count = local.ssl_private_key_enabled ? 1 : 0

  secret_id = var.ssl_private_key.id

  replication {
    auto {

    }
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "ssl_private_key" {
  count = length(google_secret_manager_secret.ssl_private_key)

  secret_data = base64encode(var.ssl_private_key.data)
  secret      = google_secret_manager_secret.ssl_private_key[count.index].id
}
