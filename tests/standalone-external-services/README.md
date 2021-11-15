# TEST: Standalone External Services Mode Terraform Enterprise

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Standalone
- External Services mode
- a small VM machine type (n1-standard-4)
- RHEL 8 as the VM image
- a publicly accessible HTTP load balancer with TLS termination
- a custom RHEL 7.9 worker image

## Pre-requisites

This test assumes the following resources exist:

- a Cloud DNS managed zone
- a Cloud Load Balancing SSL certificate
- a TFE license on a filepath accessible by tests
- a RHEL 7.9 worker image in an Artifact Registry repository

## How this test is used

This test is leveraged by the integration tests in the
`ptfe-replicated` repository.
