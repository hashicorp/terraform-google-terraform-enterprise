# Terraform Enterprise on GCP: Firewalls

This submodule provisions the firewalls of the Terraform
Enterprise cluster.

## Prerequisites

- The latest version of Terraform 0.12
  [installed](https://learn.hashicorp.com/terraform/getting-started/install)
  on your machine
- A GCP account with sufficient permissions to provision infrastructure

### Permissions

The following permissions are required by the GCP account which will be
used to provision this submodule:

- Compute Security Admin: roles/compute.securityAdmin
