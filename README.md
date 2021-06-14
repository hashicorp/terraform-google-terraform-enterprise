# Terraform Enterprise GCP Module

**IMPORTANT**: You are viewing a **beta version** of the official
module to install Terraform Enterprise. This new version is
**incompatible with earlier versions**, and it is not currently meant
for production use. Please contact your Customer Success Manager for
details before using.

This is a Terraform module for provisioning a Terraform Enterprise Cluster on GCP. Terraform Enterprise is our self-hosted distribution of Terraform Cloud. It offers enterprises a private instance of the Terraform Cloud application, with no resource limits and with additional enterprise-grade architectural features like audit logging and SAML single sign-on.

## About This Module

This module will install Terraform Enterprise on GCP according to the [HashiCorp Reference Architecture](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/gcp.html). This module is intended to be used by practitioners seeking a Terraform Enterprise installation which requires minimal configuration in the GCP cloud.

As the goal for this main module is to provide a drop-in solution for installing Terraform Enterprise via the Golden Path, it leverages GCP native solutions such as Cloud DNS and runs a basic Ubuntu 20.04 image on Cloud Compute Engine. We have provided guidance and limited examples for other use cases.

## Pre-requisites

This module is intended to run in a GCP project with minimal preparation, however it does have the following pre-requisites:

1. Create a Cloud DNS zone for the DNS name you wish to use.
2. Create a managed SSL Certificate in Network Services -> Load Balancing to serve as the certificate for the FQDN.

### Provisioning the SSL certificate

The SSL certificate for the TFE load balancer is a pre-requisite for this module.

The certificate can be provisioned in [GCP here](https://console.cloud.google.com/net-services/loadbalancing/advanced/sslCertificates/list) either by creating a managed GCP certificate or by uploading an existing certificate.

For more information on provisioning certificates in GCP, read the [documentation here](https://cloud.google.com/load-balancing/docs/ssl-certificates/google-managed-certs).

Examples of creating a self-signed certificate for use with internal load balancers can be found within the examples.

### Permissions and APIs

The following APIs are required and will be enabled by the module:

- [Cloud SQL Admin API](https://cloud.google.com/sql/docs/sqlserver/admin-api/rest)
- [Google Cloud APIs](https://cloud.google.com/apis/docs/overview)
- [Google Cloud Memorystore for Redis API](https://cloud.google.com/memorystore/docs/redis/reference/rest)
- [Identity and Access Management API](https://cloud.google.com/iam/docs)
- [Service Networking API](https://cloud.google.com/service-infrastructure/docs/service-networking/getting-started?hl=en_US)

If you are using a service account to authenticate calls to Google Cloud APIs, the following roles are required:

- [Basic Editor role](https://cloud.google.com/iam/docs/understanding-roles#basic-definitions)
- [Service Networking Admin](https://cloud.google.com/iam/docs/understanding-roles#service-networking-roles)
- [Project IAM Admin](https://cloud.google.com/iam/docs/understanding-roles#resource-manager-roles)

## How to Use This Module

- Ensure account meets module pre-requisites from above.

- Create a Terraform configuration that pulls in this module and specifies values
  of the required variables:

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

Notes:

- The `google-beta` provider is required to create the subnetwork that is reserved for Internal HTTP(S) Load Balancing.
- If you are managing DNS outside of Cloud DNS:
  - Module will output resulting load balancer IP address as `lb_address`
  - You must configure an external DNS record using the `lb_address` output

### Required inputs

`namespace` - Namespace to uniquely identify resources. Used in name prefixes

`tfe_license_path` - Local path to the TFE license

`tfe_license_name` - Name of the license

`dns_zone_name` - Name of the DNS zone in which a record set will be created

`fqdn` - Fully qualified domain name

`ssl_certificate_name` - Name of the SSL certificate provisioned in GCP

`node_count` - Number of TFE nodes to provision. A number greater than 1 will enable Active/Active

## Module Manifest

This module will create all infrastructure resources required to install Terraform Enterprise in a Standalone or Active/Active configuration (depending on how many nodes you specify) on GCP in the designated region according to the Reference Architecture. The default base machine image used is Ubuntu 20.04 LTS.

The resources created are:

- VPC with public and private subnets
- PostgreSQL instance
- Redis cache
- Google Storage Bucket
- Load Balancer
- Service Account for fetching storage objects
- Instances and Instance group manager

## Examples

- [Standalone](./examples/standalone)
- [Active/Active](./examples/active-active)
- [Existing Network](./examples/existing-network)
- [Outbound Proxy](./examples/proxy)
- [SharedVPC](./examples/shared-vpc)

Note: If you destroy and recreate the infrastructure, you will need to update the A record in Cloud DNS with the new Load Balancer address.

## License

This code is released under the Mozilla Public License 2.0. Please see [LICENSE](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/main/LICENSE)
for more details.
