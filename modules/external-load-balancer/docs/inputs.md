# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| primary\_cluster\_endpoint\_group\_self\_link | The self link of the compute network endpoint group for the primary cluster. | `string` | n/a | yes |
| ssl\_certificate\_self\_link | The self link of the managed SSL certificate which will be applied to the load balancer. | `string` | n/a | yes |
| ssl\_policy\_self\_link | The self link of a compute SSL policy for the SSL certificate. | `string` | n/a | yes |

