# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cloud\_init\_configs | The cloud-init configurations for the compute instances. | `list(string)` | n/a | yes |
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| service\_account\_email | The email address of the service account to be associated with the compute instances. | `string` | n/a | yes |
| vpc\_application\_tcp\_port | The application TCP port. | `string` | n/a | yes |
| vpc\_install\_dashboard\_tcp\_port | The install dashboard TCP port. | `string` | n/a | yes |
| vpc\_kubernetes\_tcp\_port | The Kubernetes TCP port. | `string` | n/a | yes |
| vpc\_network\_self\_link | The self link of the network to which resources will be attached. | `string` | n/a | yes |
| vpc\_subnetwork\_project | The ID of the project in which var.vpc\_subnetwork\_self\_link exists. | `string` | n/a | yes |
| vpc\_subnetwork\_self\_link | The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc\_network\_self\_link. | `string` | n/a | yes |
| disk\_image | The image from which to initialize the compute instance disks. The supported images are: ubuntu-1604-lts; ubuntu-1804-lts; rhel-7. | `string` | `"ubuntu-1804-lts"` | no |
| disk\_size | The size of var.disk\_image, expressed in units of gigabytes. | `number` | `40` | no |
| labels | The labels which will be applied to the compute instances. | `map(string)` | `{}` | no |
| machine\_type | The identifier of the set of virtualized hardware resources which will be available to the compute instances. | `string` | `"n1-standard-8"` | no |

