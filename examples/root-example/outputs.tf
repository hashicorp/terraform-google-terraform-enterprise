output "tfe-cluster" {
  value = {
    application_endpoint         = module.tfe-cluster.application_endpoint
    application_health_check     = module.tfe-cluster.application_health_check
    installer_dashboard_password = module.tfe-cluster.installer_dashboard_password
    installer_dashboard_url      = module.tfe-cluster.installer_dashboard_url
    primary_public_ip            = module.tfe-cluster.primary_public_ip
    encryption_password          = module.tfe-cluster.encryption_password
  }

  description = "Cluster information."
}
