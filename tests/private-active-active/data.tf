data "tfe_outputs" "base" {
  organization = var.tfe.organization
  workspace    = var.tfe.workspace
}

data "google_dns_managed_zone" "main" {
  name = data.tfe_outputs.base.values.cloud_dns_name
}

data "google_compute_image" "rhel" {
  name = "rhel-7-v20200403"

  project = "gce-uefi-images"
}
