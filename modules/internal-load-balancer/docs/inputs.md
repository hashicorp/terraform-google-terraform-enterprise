# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| primaries\_instance\_groups\_self\_links | The self links of the compute instance groups which comprise the primaries. | `list(string)` | n/a | yes |
| secondaries\_instance\_group\_manager\_instance\_group | The compute instance group of the secondaries. | `string` | n/a | yes |
| target\_https\_proxy\_ssl\_certificates | A list of the self links of regional SSL certificates that are used to authenticate connections with the load balancer. | `list(string)` | n/a | yes |
| vpc\_application\_tcp\_port | The application TCP port. | `string` | n/a | yes |
| vpc\_install\_dashboard\_tcp\_port | The install dashboard TCP port. | `string` | n/a | yes |
| vpc\_network\_self\_link | The self link of the network to which resources will be attached. | `string` | n/a | yes |
| vpc\_subnetwork\_self\_link | The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc\_network\_self\_link. | `string` | n/a | yes |
| labels | A collection of labels which will be applied to resources. | `map(string)` | `{}` | no |

