# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| dns\_fqdn | The routable hostname of the application endpoint. | `string` | n/a | yes |
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| primaries\_instance\_group\_self\_link | The self link of the compute instance group for the primaries. | `string` | n/a | yes |
| secondaries\_instance\_group\_manager\_instance\_group | The compute instance group of the secondaries. | `string` | n/a | yes |
| ssl\_certificate\_self\_link | The self link of the managed SSL certificate which will be applied to the load balancer. | `string` | n/a | yes |
| ssl\_policy\_self\_link | The self link of a compute SSL policy for the SSL certificate. | `string` | n/a | yes |
| vpc\_address | The address which will be assigned to the load balancer. | `string` | n/a | yes |
| vpc\_application\_tcp\_port | The application TCP port. | `string` | n/a | yes |
| vpc\_replicated\_ui\_tcp\_port | The Replicated UI TCP port. | `string` | n/a | yes |

