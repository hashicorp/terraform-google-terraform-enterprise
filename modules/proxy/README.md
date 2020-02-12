# Terraform Enterprise on GCP: Proxy

This submodule provisions the proxy of the Terraform
Enterprise cluster. The proxy is used to overcome the lack of support
for same-host [hairpinning](https://en.wikipedia.org/wiki/Hairpinning)
on GCP.

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

Traffic which originates from the leader primary node may need to be
routed back to the same node through the primary load balancer, but this
behaviour is not supported by GCP. To work around this limiation, the
proxy routes traffic through two load balancers with intermediate nodes
running [iptables](https://en.wikipedia.org/wiki/Iptables). This design
allows traffic from all nodes to be routed to the leader primary node.
