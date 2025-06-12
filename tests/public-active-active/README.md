# TEST: Public Active/Active Terraform Enterprise

## About This Test

This test for Terraform Enterprise creates an
installation with the following traits:

- Active/Active mode

- a small VM machine type (n1-standard-4)

- Ubuntu 24.04 as the VM image

- a publicly accessible HTTP load balancer with TLS termination

- no proxy server

- no Redis authentication

- no Redis encryption in transit

## Prerequisites

This test assumes the following resources exist:

- a Cloud DNS managed zone
- a Cloud Load Balancing SSL certificate
- a Secret Manager secret that comprises a Base64 encoded Replicated
  license file

## How This Test Is Used

This test is leveraged by this repository's continuous integration
setup which leverages workspaces in a Terraform Cloud workspaces as a
remote backend so that Terraform state is preserved.
