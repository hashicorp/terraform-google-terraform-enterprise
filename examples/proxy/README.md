# EXAMPLE: Deploying Terraform Enterprise behind a proxy

## About This Example

This example provisions a Standalone TFE instance behind an existing VPC and proxy.
The VPC and proxy are up to the user to configure appropriately for the TFE deployment.

To define addresses that can be reached without the proxy, configure the `no_proxy` variable to include each address in the [User Data Locals](../../modules/user_data/main.tf#L277).

## How to Use This Module

- Read the entire README.md for the [main module](https://github.com/hashicorp/terraform-google-terraform-enterprise).
- Ensure your Google credentials are set correctly.
- Add Google Terraform provider blocks for both the `google` and `google-beta` providers as detailed [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference) to a file in this directory ending with `.tf`.
- Create a local `terraform.auto.tfvars` file and instantiate the required inputs as listed in the next section.
- Ensure the pre-requisite VPC and proxy have been created.
- Create a Terraform configuration that pulls in this module and specifies values of the required variables:

```hcl
module "tfe_node" {
  source = "git@github.com:hashicorp/terraform-google-terraform-enterprise.git"

  namespace                = "<Namespace to uniquely identify resources>"
  license_secret           = "<The local path to the Terraform Enterprise license>"
  fqdn                     = "<Fully qualified domain name>"
  dns_zone_name            = "<Name of the DNS zone in which a record set will be created>"
  http_proxy_uri_authority = "<host and port of the existing proxy>"
  ca_certificate_secret    = "<Secret Manager secret comprising CA certificate>
  network                  = "<The self link of the host project's network to use>"
  subnetwork               = "<The self link of the host project's subnetwork to use>"
}
```

- Run `terraform init` and `terraform apply`

## Post-deployment Tasks

- The build should take approximately 10-15 to deploy. Once Terraform completes, give the platform another 10 minutes or so prior to attempting to interact with it in order for all containers to start up.
- Unless amended, this example will not create an initial admin user using the IACT, but does output the URL for convenience. Follow the advice in [this document](https://www.terraform.io/docs/enterprise/install/automating-initial-user.html) in order to create the initial admin user, and login to the system using this user in order to configure it for use.
