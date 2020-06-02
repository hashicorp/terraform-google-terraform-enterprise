# Create service accounts which will be used to represent various components of the application.
module "service_account" {
  # This module is sourced from the submodules of the root module through the Terraform Registry.
  source = "github.com/hashicorp/terraform-google-terraform-enterprise?ref=internal-preview//modules/service-account"

  prefix = var.prefix
}

# Configure the host project.
module "host" {
  # This module is sourced from the local filesystem because it invokes the VPC module and creates additional
  # resources which are specific to the example.
  source = "./modules/host"

  prefix                                        = var.prefix
  service_account_primaries_load_balancer_email = module.service_account.primaries_load_balancer.email
  service_account_primaries_email               = module.service_account.primaries.email
  service_account_secondaries_email             = module.service_account.secondaries.email
  service_project                               = var.service_project

  labels = var.labels
}

# Configure the service project.
module "service" {
  # This module is sourced from the local filesystem because it wraps the remaining submodules of the root
  # module for convenience.
  source = "./modules/service"

  cloud_init_license_file                       = var.cloud_init_license_file
  dns_managed_zone                              = var.dns_managed_zone
  dns_managed_zone_dns_name                     = var.dns_managed_zone_dns_name
  prefix                                        = var.prefix
  service_account_primaries_load_balancer_email = module.service_account.primaries_load_balancer.email
  service_account_primaries_email               = module.service_account.primaries.email
  service_account_secondaries_email             = module.service_account.secondaries.email
  service_account_storage_email                 = module.service_account.storage.email
  service_account_storage_key_private_key       = module.service_account.storage_key.private_key
  vpc_application_tcp_port                      = module.host.vpc.application_tcp_port
  vpc_cluster_assistant_tcp_port                = module.host.vpc.cluster_assistant_tcp_port
  vpc_etcd_tcp_port_ranges                      = module.host.vpc.etcd_tcp_port_ranges
  vpc_external_load_balancer_address            = module.host.vpc.external_load_balancer_address.address
  vpc_install_dashboard_tcp_port                = module.host.vpc.install_dashboard_tcp_port
  vpc_kubelet_tcp_port                          = module.host.vpc.kubelet_tcp_port
  vpc_kubernetes_tcp_port                       = module.host.vpc.kubernetes_tcp_port
  vpc_network_self_link                         = module.host.vpc.network.self_link
  vpc_postgresql_address_name                   = module.host.vpc.postgresql_address.name
  vpc_replicated_tcp_port_ranges                = module.host.vpc.replicated_tcp_port_ranges
  vpc_ssh_tcp_port                              = module.host.vpc.ssh_tcp_port
  vpc_subnetwork_ip_cidr_range                  = module.host.vpc.subnetwork.ip_cidr_range
  vpc_subnetwork_name                           = module.host.vpc.subnetwork.name
  vpc_subnetwork_project                        = module.host.vpc.subnetwork.project
  vpc_subnetwork_region                         = module.host.vpc.subnetwork.region
  vpc_subnetwork_self_link                      = module.host.vpc.subnetwork.self_link
  vpc_weave_tcp_port                            = module.host.vpc.weave_tcp_port
  vpc_weave_udp_port_ranges                     = module.host.vpc.weave_udp_port_ranges

  labels = var.labels
}
