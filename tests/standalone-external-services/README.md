# TEST: Standalone External Services Mode Terraform Enterprise

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Standalone
- External Services mode
- a small VM machine type (n1-standard-4)
- Ubuntu 20.04 as the VM image
- a publicly accessible HTTP load balancer with TLS termination

## Pre-requisites

This test assumes the following resources exist:

- a Cloud DNS managed zone
- a Cloud Load Balancing SSL certificate
- a TFE license on a filepath accessible by tests

## How this test is used

This test is leveraged by the integration tests in the `ptfe-replicated` repository.
