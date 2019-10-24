# Terraform Enterprise HA (Beta) Example - RedHat Enterprise Linux in Production Mode

This example assumes you have already set up your gcp project with the required prereqs:

* VPC
* Subnet specifically for Terrafrom Enterprise
* Firewall rules as outlined [in the instructions](https://www.terraform.io/docs/enterprise/beta/gcp.html#infrastructure)
* A valid certificate and ssl policy in gcp. (If you are not going to use a google managed ssl certificate, please [read the instructions here on what to comment out](https://www.terraform.io/docs/enterprise/beta/gcp.html#explanation-of-variables))
* An IP address and DNS entry for the front end load balancer
* A DNS Zone in gcp
* A license file provided by your Technical Account Manager

With this example you will create a five node cluster, running RedHat Enterprise Linux 7.6, using external services (also known as Production Mode):

![basic architecture diagram](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/v0.0.3-beta/assets/gcp_prod_diagram.png?raw=true)

## Change to the example directory

```bash
cd examples/rhel-production-example
```

## Install Terraform

Install Terraform if it is not already installed (visit [terraform.io](https://terraform.io) for other distributions):

```bash
../terraform-install.sh
```

## Set the desired options in the module block

You'll need to update the following settings to your set up:

* project: name of the project
* credentials_file: json file name
* region: where to create the resources
* zone: where to create the resources
* public_ip: The IP address to attach to the load balancer
* domain: domain to use
* dns_zone: the name of the dns zone in gcp
* certificate: the api url of the google certficiate to use
* ssl_policy: name of the ssl policy to use
* subnet: subnet to deploy into (this should be reserved for tfe)
* frontend_dns: DNS name for load balancer
* license_file: your TFE license
* encryption_password: In order to re-use external services, you need to set/pass and encryption password
* image_family: the name of the RHEL image to use - 7.6 is the latest currently supported
* gcs_bucket: name of the bucket to use. This example assume the bucket resides in the same project. 
* postgresql_address: Connection address for the postgresql server
* postgresql_database: Name of the database to use
* postgresql_user: Username to connect with
* postgresql_password: base64 encrypted password.


 This example is set to spin up a five node instance of 3 primaries and 2 secondaries, but the `primary_count` and `secondary_count` can be updated to build a larger or smaller cluster. The number of primaries should not go below 3, however.  

## Run Terraform

```bash
terraform init
terraform apply
```

## Wait for the application to load

The replicated console url will output along with the password.

![output](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/master/examples/root-example/output_example.png?raw=true)

You can log into that dashboard at that url and wait for the application to be ready. This can take up to 30 minutes! Once complete use the `Open` link to set up the admin user and initial organization.

![application started](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/master/examples/root-example/app_started.png?raw=true)
