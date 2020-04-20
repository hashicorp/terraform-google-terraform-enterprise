# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| backup\_start\_time | The time at which to start database compute instance backups, expressed in HH:MM notation. | `string` | n/a | yes |
| password | The password which will be used for authentication with the database. If no password is set then a password will be generated randomly. | `string` | n/a | yes |
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| vpc\_address\_name | n/a | `string` | n/a | yes |
| vpc\_network\_self\_link | The self link of the network to which resources will be attached. | `string` | n/a | yes |
| availability\_type | A specifier which determines if the database compute instance will be set up for high availability (REGIONAL) or single zone (ZONAL). | `string` | `"ZONAL"` | no |
| labels | A collection of labels which will be applied to the database compute instance. | `map(string)` | `{}` | no |
| machine\_type | The identifier of the set of virtualized hardware resources which will be available to the database compute instance. | `string` | `"db-custom-2-13312"` | no |
| name | The name of the database which will be used to store application data. | `string` | `"tfe"` | no |
| username | The username which will be used for authentication with the database. | `string` | `"tfe"` | no |

