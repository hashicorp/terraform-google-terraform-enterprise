# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| gcs\_bucket | The Google Cloud Storage bucket to store data in | `any` | n/a | yes |
| gcs\_credentials | The credentials JSON object to authenticate to GCS with | `any` | n/a | yes |
| gcs\_project | The Google Cloud project to access the GCS bucket within | `any` | n/a | yes |
| postgresql\_address | Address of PostgreSQL cluster to connect to | `any` | n/a | yes |
| postgresql\_database | Name of the database within the PostgreSQL cluster to use | `any` | n/a | yes |
| postgresql\_password | Password for user to connect to PostgreSQL | `any` | n/a | yes |
| postgresql\_user | User to connect to PostgreSQL as | `any` | n/a | yes |
| postgresql\_extra\_params | Additional URL parameters to use when connecting to the PostgreSQL cluster | `string` | `""` | no |

