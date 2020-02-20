# Terraform Enterprise on GCP: Global Address

This submodule provisions the global address of the Terraform
Enterprise cluster. The global address is assigned to the load balancer
which acts as a frontend to the primary and secondary compute instances.

## Prerequisites

- The latest version of Terraform 0.12
  [installed](https://learn.hashicorp.com/terraform/getting-started/install)
  on your machine
- A GCP account with sufficient permissions to provision infrastructure

### Permissions

The following permissions are required by the GCP account which will be
used to provision this submodule:

- Compute Load Balancer Admin: roles/compute.loadBalancerAdmin
