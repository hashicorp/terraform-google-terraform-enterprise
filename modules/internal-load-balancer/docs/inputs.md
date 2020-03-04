# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| port\_cluster\_assistant\_tcp | The port over which Cluster Assistant TCP traffic will travel. | `string` | n/a | yes |
| port\_kubernetes\_tcp | The port over which Kubernetes TCP traffic will travel. | `string` | n/a | yes |
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| primary\_cluster\_instance\_group\_self\_link | GCP Instance Group for the primaries | `string` | n/a | yes |
| service\_account\_email | The email address of the service account which will be associated with the proxy compute instances. | `string` | n/a | yes |
| vpc\_network\_self\_link | The self link of the network to which resources will be attached. | `string` | n/a | yes |
| vpc\_subnetwork\_ip\_cidr\_range | The range from which IP addresses will be assigned to resources, expressed in CIDR notation. The range must be part of var.vpc\_subnetwork\_self\_link. | `string` | n/a | yes |
| vpc\_subnetwork\_project | The ID of the project in which var.vpc\_subnetwork\_self\_link exists. | `string` | n/a | yes |
| vpc\_subnetwork\_self\_link | The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc\_network\_self\_link. | `string` | n/a | yes |
| labels | A collection of labels which will be applied to the compute instances. | `map(string)` | `{}` | no |

