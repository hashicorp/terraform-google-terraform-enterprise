# EXAMPLE: Deploying Terraform Enterprise behind an existing VPC

## About This Example

This is the same as the Active/Active example except it is provisioned into an existing VPC.

## How to Use This Module

The existing VPC is up to the user to configure appropriately for the TFE deployment:

- [Network Submodule](../../modules/networking) for reference.

- The [Firewall](../../modules/networking/main.tf#L34) needs to be configured to allow the load balancer to connect to the instances.

- The [Service Networking Connection](../../modules/networking/main.tf#L72) needs to be configured to allow postgres and redis to allocate IPs.

- The VPC must have a reserved subnet for the internal HTTPS load balancer.

Create a Terraform configuration that pulls in this module and specifies values of the required variables:

```hcl
provider "google" {
  project = "<your GCP project>"
  region  = "<your GCP region>"
}

provider "google-beta" {
  project = "<your GCP project>"
  region  = "<your GCP region>"
}

module "tfe_node" {
  source               = "git@github.com:hashicorp/espd-tfe-gcp.git"
  namespace            = "<Namespace to uniquely identify resources>"
  node_count           = "<Number of TFE nodes to provision>"
  tfe_license_path     = "<Local path to the TFE license>"
  tfe_license_name     = "<Name of the license>"
  fqdn                 = "<Fully qualified domain name>"
  ssl_certificate_name = "<Name of the SSL certificate provisioned in GCP>"
  dns_zone_name        = "<Name of the DNS zone in which a record set will be created>"
  network              = "<The self link of the host project's network to use>"
  subnetwork           = "<The self link of the host project's subnetwork to use>"
}
```

- Run `terraform init` and `terraform apply`

## Required inputs

`namespace` - Namespace to uniquely identify resources. Used in name prefixes

`tfe_license_path` - Local path to the TFE license

`tfe_license_name` - Name of the license

`fqdn` - Fully qualified domain name

`ssl_certificate_name` - Name of the SSL certificate provisioned in GCP

`node_count` - Number of TFE nodes to provision. A number greater than 1 will enable Active/Active

`dns_zone_name` - Name of the DNS zone in which a record set will be created

`network` - The self link of the network to use

`subnetwork` - The self link of the subnetwork to use
