# Terraform Enterprise on GCP: Internal Load Balancer

This submodule provisions the internal load balancer of the Terraform
Enterprise cluster. The internal load balancer manages traffic incoming
to the primaries from internal sources.

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

The primaries are deployed in a compute instance group which is
configured as a backend service to an internal load balancer. A GCP
internal load balancer will redirect requests from one of its backend
compute instances to the
[same requesting instance][test-from-backend-vms]. Since a new primary
attempts to join existing primaries by connecting through their load
balancer, the implication of this GCP behaviour is that the new primary
will never join as its requests will be routed back to itself. To work
around this limiation, this custom internal load balancer routes
requests through two GCP internal load balancers with intermediate
compute instances running [iptables]. This design allows requests from
all primaries and secondaries to be routed to healthy primaries.

[iptables]: https://en.wikipedia.org/wiki/Iptables
[test-from-backend-vms]: https://cloud.google.com/load-balancing/docs/internal/setting-up-internal#test-from-backend-vms
