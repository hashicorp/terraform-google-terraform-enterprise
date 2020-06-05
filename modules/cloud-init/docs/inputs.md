# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| application\_config | The application configuration. | `map(map(string))` | n/a | yes |
| license\_file | The pathname of a Replicated license file for the application. | `string` | n/a | yes |
| primaries\_load\_balancer\_address | The IP address of the primaries load balancer. | `string` | n/a | yes |
| vpc\_cluster\_assistant\_tcp\_port | The Cluster Assistant TCP port. | `string` | n/a | yes |
| vpc\_install\_dashboard\_tcp\_port | The install dashboard TCP port. | `string` | n/a | yes |
| vpc\_kubernetes\_tcp\_port | The Kubernetes TCP port. | `string` | n/a | yes |
| additional\_no\_proxy | A list of hostnames to which traffic from the application will not be proxied. | `list(string)` | `[]` | no |
| airgap\_installer\_url | The URL of an airgap package which contains the cluster installer. | `string` | `"https://install.terraform.io/installer/replicated-v5.tar.gz"` | no |
| airgap\_package\_url | The URL of an airgap package which contains a TFE release. | `string` | `""` | no |
| custom\_ca\_cert\_url | The URL of a certificate authority bundle which contains custom certificates to be trusted by the application. | `string` | `""` | no |
| distribution | The type of Linux distribution which will be running on the machines. | `string` | `"ubuntu"` | no |
| postinstall\_script | A custom shell script which will be invoked after TFE is installed. | `string` | `"echo 'A post-install script was not provided.'"` | no |
| preinstall\_script | A custom shell script which will be invoked before TFE is installed. | `string` | `"echo 'A pre-install script was not provided.'"` | no |
| proxy\_url | The URL of a proxy through which application traffic will be routed. | `string` | `""` | no |
| ptfe\_url | The URL of the cluster installer tool. | `string` | `"https://install.terraform.io/installer/ptfe-0.1.zip"` | no |
| release\_sequence | The sequence identifier of the TFE version to which the cluster will be pinned. | `string` | `"latest"` | no |
| repl\_cidr | A custom IP address range over which Replicated will communicate, expressed in CIDR notation. | `string` | `""` | no |
| ssh\_import\_id\_usernames | The usernames associated with SSH keys which will be imported from a keyserver to all machines. Refer to the cloud-init documentation for more information: https://cloudinit.readthedocs.io/en/latest/topics/modules.html#ssh-import-id | `list(string)` | `[]` | no |
| weave\_cidr | A custom IP address range over which Weave will communicate, expressed in CIDR notation. | `string` | `""` | no |

