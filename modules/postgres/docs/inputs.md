# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| install\_id | Identifier for install to apply to resources | `string` | n/a | yes |
| network\_url | Google Compute Network url to connect with | `string` | n/a | yes |
| labels | Labels to apply to the storage bucket | `map(string)` | `{}` | no |
| postgresql\_dbname | Name of Postgres Database | `string` | `"tfe"` | no |
| postgresql\_machinetype | Machine type to use for Postgres Database | `string` | `"db-custom-2-13312"` | no |
| postgresql\_password | Password for Postgres Database | `string` | `""` | no |
| postgresql\_user | Username for Postgres Database | `string` | `"tfe"` | no |
| prefix | Prefix for resources | `string` | `"tfe-"` | no |

