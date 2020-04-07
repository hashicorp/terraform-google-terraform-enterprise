# Create a VPC with a network and a subnetwork to which resources will be attached.
module "vpc" {
  source = "../../../../modules/vpc"

  prefix                                       = var.prefix
  service_account_primaries_email              = var.service_account_primaries_email
  service_account_secondaries_email            = var.service_account_secondaries_email
  service_account_internal_load_balancer_email = var.service_account_internal_load_balancer_email
}

data "google_project" "service" {
  project_id = var.service_project
}

# The Google APIs Service Agent of the service project must be authorized to use the shared VPC subnetwork in order to
# deploy from templates to managed instance groups any instances attached to the subnetwork.
resource "google_compute_subnetwork_iam_member" "network_user" {
  member     = "serviceAccount:${data.google_project.service.number}@cloudservices.gserviceaccount.com"
  role       = "roles/compute.networkUser"
  subnetwork = module.vpc.subnetwork.name
}
