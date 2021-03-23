# EXAMPLE: Deploying Terraform Enterprise in Standalone Mode

## About This Example

This example provisions a [Standalone](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/gcp.html#implementation-modes) TFE instance with minimal required inputs. This is the standard implementation for Terraform Enterprise and will create the base architecture with a single application node.


## How to Use This Module

Set the `node_count` input value to 1 to implement Standalone mode.

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
