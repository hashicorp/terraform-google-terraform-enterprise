#!/bin/bash

set -e -u -o pipefail

# Grab all the install/config data from gcp's metadata store
mkdir /etc/ptfe
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/ptfe-role" -H "Metadata-Flavor: Google" -o /etc/ptfe/role
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/bootstrap-token" -H "Metadata-Flavor: Google" -o /etc/ptfe/bootstrap-token
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/setup-token" -H "Metadata-Flavor: Google" -o /etc/ptfe/setup-token
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/cluster-api-endpoint" -H "Metadata-Flavor: Google" -o /etc/ptfe/cluster-api-endpoint
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/primary-pki-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/primary-pki-url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/health-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/health-url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/role-id" -H "Metadata-Flavor: Google" -o /etc/ptfe/role-id
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/assistant-host" -H "Metadata-Flavor: Google" -o /etc/ptfe/assistant-host
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/assistant-token" -H "Metadata-Flavor: Google" -o /etc/ptfe/assistant-token
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/ptfe-hostname" -H "Metadata-Flavor: Google" -o /etc/ptfe/hostname
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/ptfe-install-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/ptfe-install-url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/jq-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/jq-url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/repl-data" -H "Metadata-Flavor: Google" -o /etc/ptfe/repl-data
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/release-sequence" -H "Metadata-Flavor: Google" -o /etc/ptfe/release-sequence
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/http_proxy_url" -H "Metadata-Flavor: Google" -o /etc/ptfe/http_proxy_url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/custom-ca-cert-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/custom-ca-cert-url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/airgap-package-url" -H "Metadata-Flavor: Google" -o /etc/ptfe/airgap-package-url
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/b64-license" -H "Metadata-Flavor: Google" -o /etc/ptfe/replicated-licenseb64
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
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/weave_cidr" -H "Metadata-Flavor: Google" -o /etc/ptfe/weave-cidr
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/repl_cidr" -H "Metadata-Flavor: Google" -o /etc/ptfe/repl-cidr

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
PTFE_INSTALL_URL=$(cat /etc/ptfe/ptfe-install-url)
JQ_URL=$(cat /etc/ptfe/jq-url)

# Set proxy variables, if needed.
if [[ $(< /etc/ptfe/http_proxy_url) != none ]]; then
    http_proxy=$(cat /etc/ptfe/proxy-url)
    https_proxy=$(cat /etc/ptfe/proxy-url)
    export http_proxy
    export https_proxy
    export no_proxy=10.0.0.0/8,127.0.0.1,35.191.0.0/16,209.85.152.0/22,209.85.204.0/22,130.211.0.0/22

    /bin/cat <<EOF >/etc/profile.d/proxy.sh
http_proxy="$http_proxy"
https_proxy="$http_proxy"
no_proxy=10.0.0.0/8,127.0.0.1,35.191.0.0/16,209.85.152.0/22,209.85.204.0/22,130.211.0.0/22
EOF

    if [ ! -f /etc/redhat-release ]; then
        /bin/cat <<EOF >/etc/apt/apt.conf.d/00_aaa_proxy.conf
Acquire::http::proxy "$http_proxy_url";
Acquire::https::proxy "$http_proxy_url";
EOF
    fi
fi

# OS specific configs
if [ -f /etc/redhat-release ]; then
  setenforce 0
  mkdir -p /lib/tc
  mount --bind /usr/lib64/tc/ /lib/tc/
  sed -i -e 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/sysconfig/selinux
  curl -sfSL -o /usr/bin/jq $JQ_URL
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

# Store various bits of info as env vars
base64 -d /etc/ptfe/replicated-licenseb64 > /etc/replicated.rli
PTFEHOSTNAME=$(cat /etc/ptfe/hostname)
PTFEHOSTNAME=${PTFEHOSTNAME%?}
export PTFEHOSTNAME
ENCPASSWD=$(cat /etc/ptfe/encpasswd)
export ENCPASSWD
if [[ $(< /etc/ptfe/pg_user) != none ]]; then
    PG_USER=$(cat /etc/ptfe/pg_user)
    export PG_USER
    PG_PASSWORD=$(base64 --decode /etc/ptfe/pg_password)
    export PG_PASSWORD
    PG_NETLOC=$(cat /etc/ptfe/pg_netloc)
    export PG_NETLOC
    PG_DBNAME=$(cat /etc/ptfe/pg_dbname)
    export PG_DBNAME
    if [ -f /etc/ptfe/pg_extra_params ]; then
        PG_EXTRA_PARAMS=$(cat /etc/ptfe/pg_extra_params)
    else
        PG_EXTRA_PARAMS=
    fi
    export PG_EXTRA_PARAMS
    GCS_PROJECT=$(cat /etc/ptfe/gcs_project)
    export GCS_PROJECT
    GCS_BUCKET=$(cat /etc/ptfe/gcs_bucket)
    export GCS_BUCKET
    GCS_CREDS=$(base64 --decode /etc/ptfe/gcs_credentials | jq -c . | sed -e 's/"/\\"/g' -e 's/\\n/\\\\n/g')
    export GCS_CREDS
fi

# Setup the config files that will be used during the install
if [[ $(< /etc/ptfe/pg_user) == none ]]; then
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
    if [[ $(< /etc/ptfe/airgap-package-url) != none ]]; then
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
    "LicenseFileLocation":          "/etc/replicated.rli",
    "LicenseBootstrapAirgapPackagePath":    "/var/lib/ptfe/ptfe.airgap",
    "ReleaseSequence":              $RELEASE_SEQUENCE
}
EOF
    fi

else
    if [[ $(< /etc/ptfe/airgap-package-url) != none ]]; then
        /bin/cat <<EOF >/etc/replicated.conf
{
    "DaemonAuthenticationType":     "password",
    "DaemonAuthenticationPassword": "$CONSOLE",
    "TlsBootstrapType":             "self-signed",
    "BypassPreflightChecks":        true,
    "ImportSettingsFrom":           "/etc/replicated-ptfe.conf",
    "LicenseBootstrapAirgapPackagePath":    "/var/lib/ptfe/ptfe.airgap",
    "LicenseFileLocation":          "/etc/replicated.rli"
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
fi

chown root:root /etc/replicated.conf
chmod 0644 /etc/replicated.conf

pushd /tmp
  wget -O ptfe.zip $PTFE_INSTALL_URL
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

health_url="$(cat /etc/ptfe/health-url)"
role_id="$(cat /etc/ptfe/role-id)"


ptfe_install_args=(
    -DD
    "--bootstrap-token=$(cat /etc/ptfe/bootstrap-token)" \
    "--cluster-api-endpoint=$(cat /etc/ptfe/cluster-api-endpoint)" \
    --health-url "$health_url"
    "--private-address=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)"
    --assistant-host "$(cat /etc/ptfe/assistant-host)"
    --assistant-token "$(cat /etc/ptfe/assistant-token)"
)

if [ "x${role}x" == "xmainx" ]; then
    verb="setup"
    export verb
    # main
    ptfe_install_args+=(
        --cluster
        "--auth-token=@/etc/ptfe/setup-token"
    )

    if [[ $(< /etc/ptfe/http_proxy_url) != none ]]; then
        ptfe_install_args+=(
            "--additional-no-proxy=$no_proxy"
            )
    fi
    # If we are airgapping, then set the arguments needed for Replicated.
    # We also setup the replicated.conf.tmpl to include the path to the downloaded
    # airgap file.
    if [[ $(< /etc/ptfe/airgap-package-url) != none ]]; then
        ptfe_install_args+=(
            "--public-address=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)"
        )

        mkdir -p /var/lib/ptfe
        pushd /var/lib/ptfe
        airgap_url="$(< "$airgap_url_path")"
        echo "Downloading airgap package from $airgap_url"
        ptfe util download "$airgap_url" /var/lib/ptfe/ptfe.airgap
        popd 
    fi

    #If a custom weave CIDR is provided, set the necessary arguement
    if [[ $(< /etc/ptfe/weave-cidr) != "" ]]; then
        ptfe_install_args+=(
            "--ip-alloc-range=$(cat /etc/ptfe/weave-cidr)"
        )
    fi

    #If a custom Replicated service CIDR is provided, set the necessary argument
    if [[ $(< /etc/ptfe/repl-cidr) != "" ]]; then
        ptfe_install_args+=(
            "--service-cidr=$(cat /etc/ptfe/repl-cidr)"
        )
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
else
    echo "Waiting for cluster to start before continuing..."
    ptfe install join --role-id "$role_id" --health-url "$health_url" --wait-for-cluster
fi

if [ "x${role}x" != "xsecondaryx" ]; then
    ptfe_install_args+=(
        --primary-pki-url "$(cat /etc/ptfe/primary-pki-url)"
        --role-id "$role_id"
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

if [[ $(< /etc/ptfe/airgap-package-url) != none ]]; then
    mkdir -p /var/lib/ptfe
    pushd /var/lib/ptfe
    airgap_installer_url="$(< "$airgap_installer_url_path")"
    echo "Downloading airgap installer from $airgap_installer_url"
    ptfe util download "$airgap_installer_url" /var/lib/ptfe/replicated.tar.gz
    popd

    ptfe_install_args+=(
        --airgap-installer /var/lib/ptfe/replicated.tar.gz
        --airgap
    )
    fi

echo "Running 'ptfe install $verb ${ptfe_install_args[@]}'"
ptfe install $verb "${ptfe_install_args[@]}"
