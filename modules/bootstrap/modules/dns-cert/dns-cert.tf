data "google_dns_managed_zone" "dnszone" {
  name = "${var.dnszone}"
}

resource "google_compute_global_address" "frontend_ip" {
  name = "frontend-ip"
}

resource "google_dns_record_set" "hostname" {
  name = "${var.hostname}.${data.google_dns_managed_zone.dnszone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${data.google_dns_managed_zone.dnszone.name}"

  rrdatas = ["${google_compute_global_address.frontend_ip.address}"]
}

resource "google_compute_managed_ssl_certificate" "frontendcert" {
  provider = "google-beta"

  name = "${var.hostname}"

  managed {
    domains = ["${var.hostname}.${data.google_dns_managed_zone.dnszone.dns_name}"]
  }

  timeouts {
    create = "30m"
  }
}

resource "google_compute_ssl_policy" "ptfe-ssl-policy" {
  name            = "ptfe-ssl-policy"
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
}
