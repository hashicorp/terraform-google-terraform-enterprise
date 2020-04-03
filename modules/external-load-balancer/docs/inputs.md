# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| global\_address | The global IP address which will be assigned to the load balancer. | `string` | n/a | yes |
| port\_application\_tcp | The port over which application TCP traffic will travel. | `string` | n/a | yes |
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| primaries\_instance\_group\_self\_link | The self link of the compute instance group for the primaries. | `string` | n/a | yes |
| secondaries\_instance\_group\_manager\_instance\_group | The compute instance group of the secondaries. | `string` | n/a | yes |
| ssl\_certificate\_self\_link | The self link of the managed SSL certificate which will be applied to the load balancer. | `string` | n/a | yes |
| ssl\_policy\_self\_link | The self link of a compute SSL policy for the SSL certificate. | `string` | n/a | yes |

