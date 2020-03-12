## Terraform Enterprise Clustering: Primary Cluster Module

This module is responsible for creating all the resources required by
the primary cluster to function. It represent the minimum architecture
required to operate a TFE cluster.


### Components

The primary compute instances are created and then put into a compute
instance group. The instances are stateful and run the critical cluster
components for membership, health, etc. The instance group is not able
to scale and must remain at a count of 3.
