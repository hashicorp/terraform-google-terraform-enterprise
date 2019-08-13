This module installs Terraform Enterprise HA BETA onto 1 or more gcp instances in DEMO mode. All data is stored on the instance(s) and is not preserved. 

An Ubuntu Bionic (18.04 LTS) image is chosen by default, but this config support previous version of Ubuntu as well as Red Hat Enterprise Linux 7.2-7.7 (v8 is not supported.)

## Pre-req

Things required to be previously conifgured are:

- A DNS zone in gcp
- A project
- Valid credentials stored in json format
- a vcp and subnet
- firewall rules (1 allowing traffic over ports 22, 80, 443, 6443, 8800 and 23010, and a second allowing access from these CIDR blocks (for healthchecks - 35.191.0.0/16, 209.85.152.0/22, 209.85.204.0/22, and 130.211.0.0/22))
- a certificate
- a public ip address and dns entry for the load balancer

## required variables

- `project` -- name of the gcp project to install into
- `creds` -- path to and name of the json credential file to use
- `domain` -- the domain to be used
- `dnszone` -- the pre-configured dnszone
- `license_file` -- the path to and name of the rli license file 
- `cert` -- the certificate file or google api link to a managed ssl cert
- `publicip` -- the IP address to use for the front end load balancer
- `subnet` -- the subnet to deploy into
- `sslpolicy` -- the ssl policy for the certificate. If this is not required for your setup, please comment out line 14 in modules/lb/forwarding_rule.tf

## optional variables

- `region` -- the region in which to create the resources; defaults to `us-central1`
- `primary_machine_type` -- the type of instance for the primary cluster nodes to run on; defaults to `n1-standard-4` which is the minimum required
- `secondary_machine_type` -- the type of instances for the secondary cluster nodes to run on; defaults to `n1-standard-4` which is the current minimum required
- `image_family` -- the base image family to use; defaults to `ubuntu-1804-lts`
- `airgapurl` -- the link to your airgap installation package; defaults to `none` 
- `primary_count` -- the number of primary cluster nodes to stand up; defaults to `1` (should be an odd number)
- `primaryhostanme` -- the hostname prefix to use for primary cluster nudes; defaults to `ptfe-primary`
- `frontenddns` -- the name to use for the front end dns of the cluster; defaults to `ptfe`
- `zone` -- preferred zone to use; defaults to `us-central1-a`
- `workercount` -- number of secondary cluster nodes to stand up; defaults to `0`

## optional external services variables

- `external_services` -- set this to `gcs` to enable external services
- `installtype` -- set to production; defaults to poc
- `pg_user` -- the postgres user
- `pg_password` -- the password for the postgres user, base64 encoded. run `base64 <<< password` to get this value
- `pg_netloc` -- the ip address or name of the database server
- `pg_dbname` -- the name of the database to use. Please ensure the following schemas have been created: `vault`, `rails`, and `registry`
- `pg_extra_params` -- any extra connection parameters, such as `sslmode=disabled`
- `gcs_project` -- the name of the project the gcs bucket resides in
- `gcs_bucket` -- the name of the bucket to use
- `gcs_credentials` -- the base64 encoded credentials json for bucket access - only necessary if different from the credentials provided above. 

## waiting for ready

    while ! curl -sfS --max-time 5 $( terraform output ptfe_health_check ); do sleep 5; done

## connecting via ssh

    ssh -F $( terraform output ssh_config_file ) default

