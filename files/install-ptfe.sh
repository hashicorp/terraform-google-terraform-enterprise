#!/bin/bash

set -e -u -o pipefail

# Install pre-reqs
apt-get update -y
apt-get install -y jq chrony ipvsadm unzip wget
# Grab all the install/config data from gcp's metadata store
mkdir /etc/ptfe
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/ptfe-role" -H "Metadata-Flavor: Google" -o /etc/ptfe/role
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/bootstrap-token" -H "Metadata-Flavor: Google" -o /etc/ptfe/bootstrap-token
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/setup-token" -H "Metadata-Flavor: Google" -o /etc/ptfe/setup-token
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/cluster-api-endpoint" -H "Metadata-Flavor: Google" -o /etc/ptfe/cluster-api-endpoint
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/primary-pki-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/primary-pki-url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/health-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/health-url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/role-id" -H "Metadata-Flavor: Google" -o /etc/ptfe/role-id
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/ptfe-hostname" -H "Metadata-Flavor: Google" -o /etc/ptfe/hostname
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/installtype" -H "Metadata-Flavor: Google" -o /etc/ptfe/installtype
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/repl-data" -H "Metadata-Flavor: Google" -o /etc/ptfe/repl-data
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/release-sequence" -H "Metadata-Flavor: Google" -o /etc/ptfe/release-sequence
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/custom-ca-cert-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/custom-ca-cert-url

# Only grab the following if it's a primary node

if [[ $(< /etc/ptfe/role) != "secondary" ]]; then
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/b64-license" -H "Metadata-Flavor: Google" -o /etc/ptfe/replicated-licenseb64
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/airgap-package-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/airgap-package-url
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/airgap-installer-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/airgap-installer-url
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/encpasswd" -H "Metadata-Flavor: Google" -o /etc/ptfe/encpasswd
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/pg_user" -H "Metadata-Flavor: Google" -o /etc/ptfe/pg_user
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/pg_password" -H "Metadata-Flavor: Google" -o /etc/ptfe/pg_password
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/pg_netloc" -H "Metadata-Flavor: Google" -o /etc/ptfe/pg_netloc
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/pg_dbname" -H "Metadata-Flavor: Google" -o /etc/ptfe/pg_dbname
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/pg_extra_params" -H "Metadata-Flavor: Google" -o /etc/ptfe/pg_extra_params
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/gcs_credentials" -H "Metadata-Flavor: Google" -o /etc/ptfe/gcs_credentials
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/gcs_project" -H "Metadata-Flavor: Google" -o /etc/ptfe/gcs_project
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/gcs_bucket" -H "Metadata-Flavor: Google" -o /etc/ptfe/gcs_bucket
fi

if [[ $(< /etc/ptfe/role) == "secondary" ]]; then
    PTFEHOSTNAME=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)
    export PTFEHOSTNAME
fi
# Using the IP address, as the secondaries don't have DNS entries
# Primaries have to use their local hostnames as https://frontenddns:8800 will not route through the LB currently

chown root:root /etc/ptfe/*
chown 0400 /etc/ptfe/*
chown 0444 /etc/ptfe/role
chown 0444 /etc/ptfe/role-id
CONSOLE=$(base64 --decode /etc/ptfe/repl-data)
export CONSOLE
RELEASE_SEQUENCE=$(cat /etc/ptfe/release-sequence)
export RELEASE_SEQUENCE

# Store various bits of info as env vars on primary nodes
if [[ $(< /etc/ptfe/role) != "secondary" ]]; then
    base64 -d /etc/ptfe/replicated-licenseb64 > /etc/replicated.rli
    PTFEHOSTNAME=$(cat /etc/ptfe/hostname)
    PTFEHOSTNAME=${PTFEHOSTNAME%?}
    export PTFEHOSTNAME
    ENCPASSWD=$(cat /etc/ptfe/encpasswd)
    export ENCPASSWD
    PG_USER=$(cat /etc/ptfe/pg_user)
    export PG_USER
    PG_PASSWORD=$(base64 --decode /etc/ptfe/pg_password)
    export PG_PASSWORD
    PG_NETLOC=$(cat /etc/ptfe/pg_netloc)
    export PG_NETLOC
    PG_DBNAME=$(cat /etc/ptfe/pg_dbname)
    export PG_DBNAME
    PG_EXTRA_PARAMS=$(cat /etc/ptfe/pg_extra_params)
    export PG_EXTRA_PARAMS
    GCS_PROJECT=$(cat /etc/ptfe/gcs_project)
    export GCS_PROJECT
    GCS_BUCKET=$(cat /etc/ptfe/gcs_bucket)
    export GCS_BUCKET
    GCS_CREDS=$(base64 --decode /etc/ptfe/gcs_credentials | jq -c . | sed -e 's/"/\\"/g' -e 's/\\n/\\\\n/g')
    export GCS_CREDS
fi

# Setup the config files that will be used during the install
if [[ $(< /etc/ptfe/installtype) == "poc" ]]; then
    /bin/cat <<EOF >/etc/replicated-ptfe.conf
{
    "hostname": {
        "value": "$PTFEHOSTNAME"
    },
    "installation_type": {
        "value": "poc"
    }
}
EOF
else
    /bin/cat <<EOF >/etc/replicated-ptfe.conf
{
    "hostname": {
        "value": "$PTFEHOSTNAME"
    },
    "enc_password": {
        "value": "$ENCPASSWD"
    },
    "installation_type": {
        "value": "production"
    },
    "production_type": {
        "value": "external"
    },
    "pg_user": {
        "value": "$PG_USER"
    },
    "pg_password": {
        "value": "$PG_PASSWORD"
    },
    "pg_netloc": {
        "value": "$PG_NETLOC"
    },
    "pg_dbname": {
        "value": "$PG_DBNAME"
    },
    "pg_extra_params": {
        "value": "$PG_EXTRA_PARAMS"
    },
    "placement": {
        "value": "placement_gcs"
    },
    "gcs_credentials": {
        "value": "$GCS_CREDS"
    },
    "gcs_project": {
        "value": "$GCS_PROJECT"
    },
    "gcs_bucket": {
        "value": "$GCS_BUCKET"
    }
}
EOF
fi

chown root:root /etc/replicated-ptfe.conf
chmod 0644 /etc/replicated-ptfe.conf

if [[ $(< /etc/ptfe/release-sequence) != latest ]]; then
    /bin/cat <<EOF >/etc/replicated.conf
{
    "DaemonAuthenticationType":     "password",
    "DaemonAuthenticationPassword": "$CONSOLE",
    "TlsBootstrapType":             "self-signed",
    "BypassPreflightChecks":        true,
    "ImportSettingsFrom":           "/etc/replicated-ptfe.conf",
    "LicenseFileLocation":          "/etc/replicated.rli",
    "ReleaseSequence":              $RELEASE_SEQUENCE
}
EOF

else
/bin/cat <<EOF >/etc/replicated.conf
{
    "DaemonAuthenticationType":     "password",
    "DaemonAuthenticationPassword": "$CONSOLE",
    "TlsBootstrapType":             "self-signed",
    "BypassPreflightChecks":        true,
    "ImportSettingsFrom":           "/etc/replicated-ptfe.conf",
    "LicenseFileLocation":          "/etc/replicated.rli"
}
EOF
fi

chown root:root /etc/replicated.conf
chmod 0644 /etc/replicated.conf

# OS specific configs
if [ -f /etc/redhat-release ]; then
  setenforce 0
  mkdir -p /lib/tc
  mount --bind /usr/lib64/tc/ /lib/tc/
  sed -i -e 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/sysconfig/selinux
  curl -sfSL -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
  chmod +x /usr/bin/jq
  yum -y install docker ipvsadm wget unzip
  systemctl enable docker
  systemctl start docker
else
  apt-get -y update
  apt-get install -y jq chrony ipvsadm unzip wget
  CONF=/etc/chrony/chrony.conf
  SERVICE=chrony
fi

pushd /tmp
  wget -O ptfe.zip https://install.terraform.io/installer/ptfe.zip
  unzip ptfe.zip
  cp ptfe /usr/bin
  chmod a+x /usr/bin/ptfe
popd

# Replicated/TFE Install
role="$(cat /etc/ptfe/role)"
export role

if [[ $(< /etc/ptfe/airgap-package-url) != none ]]; then
    airgap_url_path="/etc/ptfe/airgap-package-url"
fi

if [[ $(< /etc/ptfe/airgap-installer-url) != none ]]; then
    airgap_installer_url_path="/etc/ptfe/airgap-installer-url"
fi

# ------------------------------------------------------------------------------
# Custom CA certificate download and configuration block
# ------------------------------------------------------------------------------
if [[ -n $(< /etc/ptfe/custom-ca-cert-url) && \
      $(< /etc/ptfe/custom-ca-cert-url) != none ]]; then
  custom_ca_bundle_url=$(cat /etc/ptfe/custom-ca-cert-url)
  custom_ca_cert_file_name=$(echo "${custom_ca_bundle_url}" | awk -F '/' '{ print $NF }')
  ca_tmp_dir="/tmp/ptfe-customer-certs"
  replicated_conf_file="replicated-ptfe.conf"
  local_messages_file="local_messages.log"
  # Setting up a tmp directory to do this `jq` transform to leave artifacts if anything goes "boom",
  # since we're trusting user input to be both a working URL and a valid certificate.
  # These artifacts will live in /tmp/ptfe/customer-certs/{local_messages.log,wget_output.log} files.
  mkdir -p "${ca_tmp_dir}"
  pushd "${ca_tmp_dir}"
  touch ${local_messages_file}
  if wget --trust-server-names "${custom_ca_bundle_url}" >> ./wget_output.log 2>&1;
  then
    if [ -f "${ca_tmp_dir}/${custom_ca_cert_file_name}" ];
    then
      if openssl x509 -in "${custom_ca_cert_file_name}" -text -noout;
      then
        mv "${custom_ca_cert_file_name}" cust-ca-certificates.crt
        cp /etc/${replicated_conf_file} ./${replicated_conf_file}.original
        jq ". + { ca_certs: { value: \"$(cat cust-ca-certificates.crt)\" } }" -- ${replicated_conf_file}.original > ${replicated_conf_file}.updated
        if jq -e . > /dev/null 2>&1 -- ${replicated_conf_file}.updated;
        then
          cp ./${replicated_conf_file}.updated /etc/${replicated_conf_file}
        else
          echo "The updated ${replicated_conf_file} file is not valid JSON." | tee -a "${local_messages_file}"
          echo "Review ${ca_tmp_dir}/${replicated_conf_file}.original and ${ca_tmp_dir}/${replicated_conf_file}.updated." | tee -a "${local_messages_file}"
          echo "" | tee -a "${local_messages_file}"
        fi
      else
        echo "The certificate file wasn't able to validated via openssl" | tee -a "${local_messages_file}"
        echo "" | tee -a "${local_messages_file}"
      fi
    else
      echo "The filename ${custom_ca_cert_file_name} was not what ${custom_ca_bundle_url} downloaded." | tee -a "${local_messages_file}"
      echo "Inspect the ${ca_tmp_dir} directory to verify the file that was downloaded." | tee -a "${local_messages_file}"
      echo "" | tee -a "${local_messages_file}"
    fi
  else
    echo "There was an error downloading the file ${custom_ca_cert_file_name} from ${custom_ca_bundle_url}." | tee -a "${local_messages_file}"
    echo "See the ${ca_tmp_dir}/wget_output.log file." | tee -a "${local_messages_file}"
    echo "" | tee -a "${local_messages_file}"
  fi

  popd
fi

ptfe_install_args=(
    -DD
    "--bootstrap-token=$(cat /etc/ptfe/bootstrap-token)" \
    "--cluster-api-endpoint=$(cat /etc/ptfe/cluster-api-endpoint)" \
    --health-url "$(cat /etc/ptfe/health-url)"
    "--private-address=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)"
)

if [ "x${role}x" == "xmainx" ]; then
    verb="setup"
    export verb
    # main
    ptfe_install_args+=(
        --cluster
        "--auth-token=@/etc/ptfe/setup-token"
    )
    # If we are airgapping, then set the arguments needed for Replicated.
    # We also setup the replicated.conf.tmpl to include the path to the downloaded
    # airgap file.
    if [[ $(< /etc/ptfe/airgap-package-url) != none ]]; then
        mkdir -p /var/lib/ptfe
        pushd /var/lib/ptfe
        curl -sfSL -o ptfe.airgap "$(< "$airgap_url_path")"
        airgap_path=$( readlink -f ptfe.airgap )
        curl -sfSL -o replicated.tar.gz "$(< "${airgap_installer_url_path}")"
        replicated_installer_path=$( readlink -f replicated.tar.gz )
        popd

        # replace the airgap path URL with the file path from above
        jq \
            --arg airgap_path "${airgap_path}" \
            '. += {
                "LicenseBootstrapAirgapPackagePath": $airgap_path
            }' \
            \
            /etc/replicated.conf.tmpl \
            > /etc/replicated.conf

        # main with airgap
        ptfe_install_args+=(
            # --no-proxy
            "--public-address=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)"
            "--airgap-installer ${replicated_installer_path}"
        )
    fi
fi

if [ "x${role}x" != "xsecondaryx" ]; then
    ptfe_install_args+=(
        --primary-pki-url "$(cat /etc/ptfe/primary-pki-url)"
        --role-id "$(cat /etc/ptfe/role-id)"
    )
fi

if [ "x${role}x" == "xprimaryx" ]; then
    verb="join"
    ptfe_install_args+=(
        --as-primary
    )
    export verb
fi

if [ "x${role}x" == "xsecondaryx" ]; then
    verb="join"
    export verb
fi

ptfe install $verb "${ptfe_install_args[@]}"
