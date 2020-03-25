## Terraform Enterprise Clustering: Primary Cluster Module

This module is responsible for creating all the resources required by
the primary cluster to function. It represent the minimum architecture
required to operate a TFE cluster.


### Components

The primary compute instances are created and then put into a compute
instance group. The instances are stateful and run the critical cluster
components for membership, health, etc.


### Limitations

TFE does not support scaling the primary cluster. The instance group is
hard-coded to a count of 3 to ensure that the control plane can achieve
quorum and that the internal service mode has sufficient capacity.
