# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| port\_application\_tcp | The port over which application TCP traffic will travel. | `string` | n/a | yes |
| port\_cluster\_assistant\_tcp | The port over which Cluster Assistant TCP traffic will travel. | `string` | n/a | yes |
| port\_etcd\_tcp\_ranges | The port ranges over which etcd TCP traffic will travel. | `list(string)` | n/a | yes |
| port\_kubelet\_tcp | The port over which Kubelet TCP traffic will travel. | `string` | n/a | yes |
| port\_kubernetes\_tcp | The port over which Kubernetes TCP traffic will travel. | `string` | n/a | yes |
| port\_replicated\_tcp\_ranges | The port ranges over which Replicated TCP traffic will travel. | `list(string)` | n/a | yes |
| port\_replicated\_ui\_tcp | The port over which Replicated UI TCP traffic will travel. | `string` | n/a | yes |
| port\_ssh\_tcp | The port over which SSH TCP traffic will travel. | `string` | n/a | yes |
| port\_weave\_tcp | The port over which Weave TCP traffic will travel. | `string` | n/a | yes |
| port\_weave\_udp\_ranges | The port ranges over which Weave UDP traffic will travel. | `list(string)` | n/a | yes |
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| service\_account\_internal\_load\_balancer\_email | The email address of the service account associated with the internal load balancer. | `string` | n/a | yes |
| service\_account\_primaries\_email | The email address of the service account associated with the primaries. | `string` | n/a | yes |
| service\_account\_secondaries\_email | The email address of the service account associated with the secondaries. | `string` | n/a | yes |
| vpc\_network\_self\_link | The self link of the network to which resources will be attached. | `string` | n/a | yes |
| vpc\_subnetwork\_ip\_cidr\_range | The range of IP addresses in the subnetwork from which traffic will be authorized to flow, expressed in CIDR notation. | `string` | n/a | yes |
| health\_check\_ip\_cidr\_ranges | The list of GCP health check IP address ranges from which health check traffic will be authorized to flow, expressed in CIDR notation. The default ranges were obtained from the GCP Health Checks Overview: https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges. | `list(string)` | <pre>[<br>  "35.191.0.0/16",<br>  "130.211.0.0/22"<br>]</pre> | no |

