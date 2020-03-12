# Terraform Enterprise on GCP: Internal Load Balancer

This submodule provisions the internal load balancer of the Terraform
Enterprise cluster. The internal load balancer manages traffic incoming
to the primary cluster from internal sources.

## Prerequisites

- The latest version of Terraform 0.12
  [installed](https://learn.hashicorp.com/terraform/getting-started/install)
  on your machine
- A GCP account with sufficient permissions to provision infrastructure

### Permissions

The following permissions are required by the GCP account which will be
used to provision this submodule:

- Compute Admin: roles/compute.admin

## Function

A GCP internal load balancer will
redirect requests from one of its backend compute instances to the
[same requesting instance][test-from-backend-vms].
The implication of this behaviour is that requests from a new primary
compute instance attempting to join an existing cluster will never be
routed to active primary compute instances. To work around this
limiation, the custom internal load balancer routes requests through
two GCP internal load balancers with intermediate compute instances
running [iptables]. This design allows requests from all primary and
secondary compute instances to be routed to healthy primary compute
instances.

[iptables]: https://en.wikipedia.org/wiki/Iptables
[test-from-backend-vms]: https://cloud.google.com/load-balancing/docs/internal/setting-up-internal#test-from-backend-vms
