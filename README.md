# Terraform Enterprise: Clustering for Google

![Terraform Logo](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/master/assets/TerraformLogo.png?raw=true)

## Description

This module installs Terraform Enterprise Clustering onto one or more gcp instances.

An Ubuntu Bionic (18.04 LTS) image is chosen by default, but this config supports previous version of Ubuntu as well as Red Hat Enterprise Linux 7.2-7.6 (v8 are not supported.)

## Architecture

![basic diagram](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/master/assets/gcp_diagram.jpg?raw=true)
_example architecture_

Please contact your Technical Account Manager for more information, and support for any issues you have.

## Usage

The following sections describe aspects of using this
module.

### Permissions

The following roles must be assigned to the GCP identity
used to provision this module:

- Cloud SQL Admin: `roles/cloudsql.admin`
- Compute Admin: `roles/compute.admin`
- Service Account Admin:
  `roles/iam.serviceAccountAdmin`
- DNS Administrator: `roles/dns.admin`
- Service Networking Admin:
  `roles/servicenetworking.networksAdmin`
- Service Account Key Admin:
  `roles/iam.serviceAccountKeyAdmin`
- Service Account User: `roles/iam.serviceAccountUser`
- Storage Admin: `roles/storage.admin`

### Examples

Please see the [examples directory](https://github.com/hashicorp/terraform-google-terraform-enterprise/tree/master/examples/) for more extensive examples.

### Inputs

Please see the [inputs documentation](https://registry.terraform.io/modules/hashicorp/terraform-enterprise/google/?tab=inputs)

Repository versions of the inputs documentation can be found in [docs/inputs.md](docs/inputs.md)

### Outputs

Please see the [outputs documentation](https://registry.terraform.io/modules/hashicorp/terraform-enterprise/google/?tab=outputs)

Repository versions of the outputs documentation can be found in [docs/outputs.md](docs/outputs.md)
