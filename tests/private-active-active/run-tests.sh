#!/bin/bash

k6_path=""
k6_tests_dir=""
bastion_key_file=""
skip_init=""
bind_to_localhost=""

Help()
{
   # Display Help
   echo "This script bootstraps the k6 / tfe-load-test environment and executes a smoke-test against an active TFE instance deployed with the terraform-azure-terraform-enterprise module."
   echo
   echo "Syntax: run-tests.sh [-h|k|t|b|s|l]"
   echo "options:"
   echo "h     Print this Help."
   echo "k     (required) The path to the k6 binary."
   echo "t     (required) The path to the tfe-load-test repository."
   echo "s     (optional) Skip the admin user initialization and tfe token retrieval (This is useful for secondary / repeated test runs)."
   echo "l     (optional) Bind the test proxy to localhost instead of the detected ip address (This is useful when testing from within a docker container)."
   echo
}

# Get the options
while getopts ":hk:t:b:sl" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      k) # Enter a path to the k6 binary
         k6_path=$OPTARG;;

      t) # Enter a path to the tfe-load-test repo
         k6_tests_dir=$OPTARG;;
      s) # Skip the admin user boostrapping process?
         skip_init=1;;
      l) # Bind test proxy to localhost
         bind_to_localhost=1;;   
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

if [[ -z "$k6_path" ]]; then
    echo "k6 path missing. Please use the -k option."
    Help
    exit 1
fi

if [[ -z "$k6_tests_dir" ]]; then
    echo "The tfe-load-test repository path missing. Please use the -t option."
    Help
    exit 1
fi

echo "
Executing tests with the following configuration:
    k6_path=$k6_path
    k6_tests_dir=$k6_tests_dir
    skip_init=$skip_init
    bind_to_localhost=$bind_to_localhost
"

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

cd $SCRIPT_DIR
health_check_url=$(terraform output -no-color -raw health_check_url)
echo "health check url: $health_check_url"

#Retrieve Proxy Instance Name
INSTANCE_NAME=`terraform output -no-color -raw proxy_instance_name`
#Retrieve Instance Zone
INSTANCE_ZONE=`terraform output -no-color -raw proxy_instance_zone`
#Initiate SSH tunnel to proxy server
gcloud compute ssh --quiet --ssh-key-expire-after="1440m" --tunnel-through-iap --zone="$INSTANCE_ZONE" "$INSTANCE_NAME" -- -f -N -p 22 -D localhost:5000

if [[ -z "$skip_init" ]]; then
    while ! curl \
            -sfS --max-time 5 --proxy socks5://localhost:5000 \
            $health_check_url; \
            do sleep 5; done
    echo " : TFE is healthy and listening."

    tfe_url=$(terraform output -no-color -raw tfe_url)
    echo "tfe url: $tfe_url"
    iact_url=$(terraform output -no-color -raw iact_url)
    echo "iact url: $iact_url"
    echo "Fetching iact token.."
    iact_token=$(curl --fail --retry 5 --proxy socks5://localhost:5000 "$iact_url")
    admin_url=`terraform output -no-color -raw initial_admin_user_url`
    echo "admin url: $admin_url"

    TFE_USERNAME="test$(date +%s)"
    TFE_PASSWORD=`openssl rand -base64 32`
    echo "{\"username\": \"$TFE_USERNAME\", \"email\": \"tf-onprem-team@hashicorp.com\", \"password\": \"$TFE_PASSWORD\"}" \ > ./payload.json

    response=$(\
               curl \
                --retry 5 \
                --header 'Content-Type: application/json' \
                --data @./payload.json \
                --request POST \
                --proxy socks5://localhost:5000 \
                "$admin_url"?token="$iact_token")

    echo "$response"
    tfe_token=$(echo "$response" | jq --raw-output '.token')
    rm -f payload.json

    echo "export K6_PATHNAME=$k6_path
          export TFE_URL=$tfe_url
          export TFE_API_TOKEN=$tfe_token
          export TFE_EMAIL=tf-onprem-team@hashicorp.com
          export http_proxy=socks5://localhost:5000/
          export https_proxy=socks5://localhost:5000/" > .env.sh
fi

source .env.sh
cd $k6_tests_dir
make smoke-test