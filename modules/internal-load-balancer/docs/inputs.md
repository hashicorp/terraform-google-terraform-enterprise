# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| primaries\_addresses | The IP addresses of the primaries. | `list(string)` | n/a | yes |
| service\_account\_email | The email address of the service account to be associated with the compute instances. | `string` | n/a | yes |
| ssl\_bundle\_url | The URL of an SSL certificate and private key bundle to be used for application traffic authentication. The file located at the URL must be in PEM format. | `string` | n/a | yes |
| vpc\_application\_tcp\_port | The application TCP port. | `string` | n/a | yes |
| vpc\_install\_dashboard\_tcp\_port | The install dashboard TCP port. | `string` | n/a | yes |
| vpc\_subnetwork\_project | The ID of the project in which var.vpc\_subnetwork\_self\_link exists. | `string` | n/a | yes |
| vpc\_subnetwork\_self\_link | The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc\_network\_self\_link. | `string` | n/a | yes |
| disk\_image | The image from which the main compute instance disks will be initialized. The supported images are: ubuntu-1604-lts; ubuntu-1804-lts; rhel-7. | `string` | `"ubuntu-1804-lts"` | no |
| disk\_size | The size of var.disk\_image, expressed in units of gigabytes. | `number` | `40` | no |
| labels | The labels which will be applied to the compute instances. | `map(string)` | `{}` | no |
| machine\_type | The identifier of the set of virtualized hardware resources which will be available to the compute instances. More details on machine types can be found at https://cloud.google.com/compute/docs/machine-types | `string` | `"n1-standard-8"` | no |

