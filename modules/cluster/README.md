## Terraform Enterprise Clustering: Cluster Module

This module is responsible for creating all the resources required by the cluster to function. It represent the minimum
architecture required to operate a TFE cluster.


### Components

#### Primary Instances

These instances are created as GCP Instances directly and then put into a Instance Group. The primaries are stateful
and run the critical cluster components for membership, health, etc.

#### Internal Load Balancer

An internal loadbalancer is created by a Compute Instance Group Manager that spawns 2 Compute Instances that run
haproxy, forwarding traffic to the primaries. These haproxy instances are themselves accessed via a GCP Forwarding
Rule and Backend Service that directly traffic to them.

This internal load balancer is used by the primaries as well as the secondary instances to access the cluster services
on the primaries.

The reason the haproxy instances are used instead of simply using a GCP Forwarding Rule and Backend Service that points
to the primary instances is that the limitations in GCP's TCP load balancing won't allow the cluster to be properly
created, as instances within a Backend Service can not access that same Backend Service normally. This results in an
instance being unable to properly join the cluster.

#### Secondary Instances

These instances are created using a Compute Instance Group Manager that spawn a configurable number of Compute Instances.
Once running, these instances join the cluster and run stateless components such as TFE API services as well as
performing Terraform runs.
