# EXAMPLE: Deploying Terraform Enterprise behind a proxy

## About This Example

This example provisions a Standalone TFE instance behind an existing VPC and proxy.
The VPC and proxy are up to the user to configure appropriately for the TFE deployment.

To define addresses that can be reached without the proxy, configure the `no_proxy` variable to include each address in the [User Data Locals](../../modules/user_data/main.tf#L277).

## How to Use This Module

- Ensure the pre-requisite VPC and proxy have been created

- Create a Terraform configuration that pulls in this module and specifies values of the required variables:

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
  proxy_ip             = "<IP address of the existing proxy>"
  proxy_cert_name      = "<Name of the proxy CA certificate bundle>"
  proxy_cert_path      = "<Local path to the CA certificate bundle>"
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

`proxy_cert_name` - Name of the proxy CA certificate bundle

`proxy_cert_path` - Local path to the CA certificate bundle

`proxy_ip` - IP address of the existing proxy

`dns_zone_name` - Name of the DNS zone in which a record set will be created

`network` - The self link of the host project's network to use

`subnetwork` - The self link of the host project's subnetwork to use
