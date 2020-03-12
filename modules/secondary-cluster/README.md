## Terraform Enterprise Clustering: Secondary Cluster Module

This module is responsible for creating all the resources required by
the secondary cluster to function.

### Components

The instances are created using a compute instance group manager which
scales to a configurable number of compute instances. Once running,
these instances join the cluster and run stateless components such as
TFE API services as well as performing Terraform runs.
