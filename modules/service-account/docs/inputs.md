# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| bucket | GCS Bucket to give permissions on | `string` | n/a | yes |
| install\_id | Identifier for install to apply to resources | `string` | n/a | yes |
| prefix | Prefix for resources | `string` | `"tfe-"` | no |

