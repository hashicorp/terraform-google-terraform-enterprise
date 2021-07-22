# EXAMPLE: Using this module with a SharedVPC

## About This Example

This is the same as the existing network example except it is provisioned into a VPC in a host project.

## How to Use This Module

The SharedVPC is up to the user to configure appropriately for the TFE deployment.

For network configuration, refer to the [existing-network example](../existing-network).

Documentation on setting up a SharedVPC can be found [here](https://cloud.google.com/vpc/docs/provisioning-shared-vpc).
The SharedVPC needs to be configured in the host project, and the service user must have permissions to create resources
on the host project from the service project.

Create a Terraform configuration that pulls in this module and specifies values of the required variables:

```hcl
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

`network` - The self link of the host project's network to use

`subnetwork` - The self link of the host project's subnetwork to use
