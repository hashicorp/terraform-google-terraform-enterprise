# Terraform Enterprise Clustered: Internal Load Balancer Module

This module comprises resources which create an internal load balancer. 
Internal load balancers are intended to balance user traffic which 
originates from within a GCP VPC rather than the public Internet.

## Caveats

The internal load balancer only handles traffic for the application; the 
install dashboard must be accessed with a direct connection to a primary 
or secondary compute instance.

The internal load balancer does not support Shared VPC deployments due to
[limitations of internal HTTP(S) load balancing][load-balancing-limitations].

<!-- URLs for links -->

[load-balancing-limitations]: https://cloud.google.com/load-balancing/docs/l7-internal#limitations