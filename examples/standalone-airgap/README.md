# EXAMPLE: Standalone, Airgapped Package Installation of Terraform Enterprise

## About This Example

This example for Terraform Enterprise creates a TFE installation with the following traits.

- [Standalone](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/gcp.html#implementation-modes)
- Airgapped installation
- a small VM machine type (n1-standard-4)
- Ubuntu 20.04 as the VM image
- a publicly accessible HTTP load balancer with TLS termination

## Pre-requisites

This example assumes that it is being run in a completely air-gapped environment and that the
user has already prepared the virtual machine (vm) image with the prerequisites for an airgapped
installation. This requires the following:

- a DNS zone
- The vm image is prepared according to the [documentation](https://www.terraform.io/enterprise/install/interactive/installer#prepare-the-instance).
- TFE license is on a filepath defined by `var.tfe_license_file_location`.
- The airgap package is on a filepath defined by `var.tfe_license_bootstrap_airgap_package_path`.
- The extracted Replicated package from 
https://s3.amazonaws.com/replicated-airgap-work/replicated.tar.gz is at
`/tmp/replicated/replicated.tar.gz`.
- Certificate and key data is present on the vm image at the following paths (when applicable):
  - The value of the secret represented by the root module's `ssl_certificate_secret` variable
  is present at the path defined by `var.tls_bootstrap_cert_pathname` (`0600` access permissions).
  - The value of the secret represented by the root module's `ssl_private_key_secret` is present at the
  path defined by `var.tls_bootstrap_key_pathname` (`0600` access permissions).
  - The value of the secret represented by the root module's `ca_certificate_secret_id` is present
  at the path:
    - for Red Hat - `/usr/share/pki/ca-trust-source/anchors/tfe-ca-certificate.crt`
    - for Ubuntu - `/usr/local/share/ca-certificates/extra/tfe-ca-certificate.crt`

## How to Use This Module

- Read the entire README.md for the [main module](https://github.com/hashicorp/terraform-google-terraform-enterprise).
- Ensure your Google credentials are set correctly
- Add Google Terraform provider blocks for both the `google` and `google-beta` providers as detailed [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference) to a file in this directory ending with `.tf`.
- Create a local `terraform.auto.tfvars` file and instantiate the required inputs as listed in the next section.
- Set the `node_count` input value to 1 to implement Standalone mode.
- Create a Terraform configuration that pulls in this module and specifies values of the required variables:

```hcl
module "tfe_node" {
  source                = "git@github.com:hashicorp/terraform-google-terraform-enterprise.git"
  namespace             = "<Namespace to uniquely identify resources>"
  node_count            = "<Number of TFE nodes to provision>"
  tfe_license_secret_id = null
  fqdn                  = "<Fully qualified domain name>"
  ssl_certificate_name  = "<Name of the SSL certificate provisioned in GCP>"
  dns_zone_name         = "<Name of the DNS zone in which a record set will be created>"
  load_balancer         = "PUBLIC"  // for a publically accessible instance.  Omit this line for a private instance, or explicitly set it to "PRIVATE"
}
```

- Run `terraform init` and `terraform apply`

## Post-deployment Tasks

- The build should take approximately 10-15 to deploy.  Once Terraform completes, give the platform
another 10 minutes or so prior to attempting to interact with it in order for all containers to start up.
- Unless amended, this example will not create an initial admin user using the IACT, but does output the
URL for convenience. Follow the advice in [this document](https://www.terraform.io/docs/enterprise/install/automating-initial-user.html)
in order to create the initial admin user, and login to the system using this user in order to configure
it for use.
