# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| service\_account\_primaries\_email | The email address of the service account associated with the primaries. | `string` | n/a | yes |
| service\_account\_primaries\_load\_balancer\_email | The email address of the service account associated with the primaries load balancer. | `string` | n/a | yes |
| service\_account\_secondaries\_email | The email address of the service account associated with the secondaries. | `string` | n/a | yes |
| application\_tcp\_port | The Application TCP port. The value must be supported for HTTPS load balancing. More information is available at https://cloud.google.com/load-balancing/docs/https. | `string` | `"443"` | no |
| cluster\_assistant\_tcp\_port | The Cluster Assistant TCP port. | `string` | `"23010"` | no |
| etcd\_tcp\_port\_ranges | The etcd TCP port ranges. | `list(string)` | <pre>[<br>  "2379",<br>  "2380",<br>  "4001",<br>  "7001"<br>]</pre> | no |
| health\_check\_ip\_cidr\_ranges | A list of GCP health check IP address ranges from which health check traffic will be authorized to flow. The values must expressed in CIDR notation. The default values were obtained from the GCP Health Checks Overview article: https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges. | `list(string)` | <pre>[<br>  "35.191.0.0/16",<br>  "130.211.0.0/22"<br>]</pre> | no |
| install\_dashboard\_tcp\_port | The install dashboard TCP port. The value must be supported for TCP load balancing. More information is available at https://cloud.google.com/load-balancing/docs/tcp. | `string` | `"8085"` | no |
| internal\_load\_balancer\_subnetwork\_ip\_cidr\_range | The range of IP addresses to provision in the internal load balancer subnetwork. The value must be expressed in CIDR notation. The default value was obtained from the GCP Proxy Only Subnets article: https://cloud.google.com/load-balancing/docs/l7-internal/proxy-only-subnets#proxy_only_subnet_create | `string` | `"10.2.0.0/23"` | no |
| kubelet\_tcp\_port | The Kubelet TCP port. | `string` | `"10250"` | no |
| kubernetes\_tcp\_port | The Kubernetes TCP port. | `string` | `"6443"` | no |
| replicated\_tcp\_port\_ranges | The Replicated TCP port ranges. | `list(string)` | <pre>[<br>  "9870-9881"<br>]</pre> | no |
| ssh\_tcp\_port | The SSH TCP port. | `string` | `"22"` | no |
| subnetwork\_ip\_cidr\_range | The range of IP addresses to provision in the subnetwork. The value must be expressed in CIDR notation. | `string` | `"10.1.0.0/16"` | no |
| weave\_tcp\_port | The Weave ports. | `string` | `"6783"` | no |
| weave\_udp\_port\_ranges | The Weave UDP port ranges. | `list(string)` | <pre>[<br>  "6783",<br>  "6784"<br>]</pre> | no |

