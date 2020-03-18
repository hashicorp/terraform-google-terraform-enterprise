# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ca\_certs | The contents of a certificate authority bundle which contains custom certificates to be trusted by the application, expressed as the concatenated contents of one or more certificate files. | `string` | n/a | yes |
| capacity\_memory | The amount of memory to allocate for each Terraform run, expressed in units of megabytes. | `number` | n/a | yes |
| custom\_image\_name | The name of a custom Docker image which will be used to provision Terraform Build Workers. var.tbw\_image must be set to 'custom\_image' in order for this variable to be used. | `string` | n/a | yes |
| dns\_fqdn | The routable hostname of the application endpoint. | `string` | n/a | yes |
| enc\_password | The password which will be used to encrypt sensitive data at rest. | `string` | n/a | yes |
| extern\_vault\_addr | The URL of the external Vault cluster. var.extern\_vault\_addr must be set in order for this variable to be used. | `string` | n/a | yes |
| extern\_vault\_path | The path to the AppRole auth method on the external Vault cluster. var.extern\_vault\_addr must be set in order for this variable to be used. | `string` | n/a | yes |
| extern\_vault\_role\_id | The RoleID of the AppRole to be used for authentication with the external Vault cluster. var.extern\_vault\_addr must be set in order for this variable to be used. | `string` | n/a | yes |
| extern\_vault\_secret\_id | The SecretID of the AppRole to be used for authentication with the external Vault cluster. var.extern\_vault\_addr must be set in order for this variable to be used. | `string` | n/a | yes |
| extern\_vault\_token\_renew | The period of time between renewals of the external Vault cluster token, expressed in units of seconds. var.extern\_vault\_addr must be set in order for this variable to be used. | `number` | n/a | yes |
| iact\_subnet\_time\_limit | The amount of time to allow for access to the Initial Admin Creation Token API from var.iact\_subnet\_list, expressed in units of minutes. A value of 'unlimited' will disable the limit. | `string` | n/a | yes |
| postgresql\_database\_instance\_address | The hostname and optional port of the PostgreSQL cluster, expressed in hostname:port notation. | `string` | n/a | yes |
| postgresql\_database\_name | The name of the database on the PostgreSQL cluster which will be used to store application data. | `string` | n/a | yes |
| postgresql\_user\_name | The username which will be used to authenticate with the PostgreSQL cluster. | `string` | n/a | yes |
| postgresql\_user\_password | The password which will be used to authenticate with the PostgreSQL cluster. | `string` | n/a | yes |
| service\_account\_storage\_key\_private\_key | The private key of the service account which is authorized to manage the storage bucket, expressed in Base64 encoding. | `string` | n/a | yes |
| storage\_bucket\_name | The name of the storage bucket which will be used to hold application state information. | `string` | n/a | yes |
| storage\_bucket\_project | The ID of the project which hosts the storage bucket. | `string` | n/a | yes |
| tbw\_image | A selector which determines if the Terraform Build Workers are provisioned from the default Docker image or a custom Docker image. The valid values are: default\_image; custom\_image. | `string` | n/a | yes |
| tls\_vers | The versions of TLS to be supported in communication with the application. The valid values are: tls\_1\_2\_tls\_1\_3; tls\_1\_2; tls\_1\_3. | `string` | n/a | yes |
| additional\_no\_proxy | A list of hostnames to which traffic from the application will not be proxied. | `list(string)` | `[]` | no |
| iact\_subnet\_list | A list of IP address ranges from which access to the Initial Admin Creation Token API will be authorized, expressed in CIDR notation. | `list(string)` | `[]` | no |
| postgresql\_extra\_params | A collection of additional URL parameters which will be used when connecting to the PostgreSQL cluster. | `map(string)` | `{}` | no |

