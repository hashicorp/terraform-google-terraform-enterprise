# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cloud\_init\_license\_file | The pathname of a Replicated license file for the application. | `string` | n/a | yes |
| dns\_managed\_zone | The name of the managed DNS zone in which the application will be accessible. | `string` | n/a | yes |
| dns\_managed\_zone\_dns\_name | The fully qualified DNS name of the managed zone set by var.dns\_managed\_zone. | `string` | n/a | yes |
| labels | A collection of labels which will be applied to resources. | `map(string)` | `{}` | no |
| prefix | The prefix which will be prepended to the names of resources. | `string` | `"tfe-"` | no |
| release\_sequence | The sequence identifier of the TFE version to which the cluster will be pinned. | `string` | `"latest"` | no |
| secondaries\_max\_instances | The maximum count of compute instances to which the secondaries may scale. The default value is derived from the secondaries submodule. | `number` | `5` | no |
| secondaries\_min\_instances | The minimum count of compute instances to which the secondaries may scale. The default value is derived from the secondaries submodule. | `number` | `1` | no |

