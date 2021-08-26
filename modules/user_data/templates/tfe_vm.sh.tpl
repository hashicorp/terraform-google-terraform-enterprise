#!/usr/bin/env bash
set -e -u -o pipefail

release_name=$(grep "^NAME=" /etc/os-release | cut -d"\"" -f2)

case "$release_name" in
  "Red Hat"*)
    distribution="rhel"
    ;;
  "Ubuntu"*)
    distribution="ubuntu"
    ;;
  *)
    echo "Unsupported operating system detected"
    exit 1
esac

# Provision settings
echo "${settings}" | base64 --decode > /etc/ptfe-settings.json
echo "${replicated}" | base64 --decode > /etc/replicated.conf
echo "${docker_config}" | base64 --decode > /etc/docker/daemon.json

%{ if proxy_ip != "" ~}
# Proxy Config
/bin/cat <<EOF >>/etc/environment
http_proxy="http://${proxy_ip}"
https_proxy="https://${proxy_ip}"
no_proxy="${no_proxy}"
EOF

/bin/cat <<EOF >/etc/profile.d/proxy.sh
http_proxy="http://${proxy_ip}"
https_proxy="https://${proxy_ip}"
no_proxy="${no_proxy}"
EOF

export http_proxy="http://${proxy_ip}"
export https_proxy="https://${proxy_ip}"
export no_proxy="${no_proxy}"

%{ endif ~}
%{ if ca_certificate_secret != null ~}
ca_certificate_directory="/dev/null"

if [[ $distribution == "ubuntu" ]]
then
  ca_certificate_directory="/usr/local/share/ca-certificates/extra"
elif [[ $distribution == "rhel" ]]
  ca_certificate_directory="/usr/share/pki/ca-trust-source/anchors"
fi

mkdir --parents "$ca_certificate_directory"

certificate_data="$( \
  http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${ca_certificate_secret}" | \
    base64 --decode --ignore-garbage \
)"
echo "$certificate_data" > "$ca_certificate_directory/tfe-ca-certificate.crt"

if [[ $distribution == "ubuntu" ]]
then
  update-ca-certificates
  apt-get -y update
  apt-get -y install jq
elif [[ $distribution == "rhel" ]]
then
  update-ca-trust
  yum -y install jq
fi

cp /etc/ptfe-settings.json /etc/ptfe-settings-without-ca-certs.json
jq ". + { ca_certs: { value: \"$certificate_data\" } }" -- /etc/ptfe-settings-without-ca-certs.json > ptfe-settings.json

%{ endif ~}
mkdir -p /etc/docker
mkdir -p /opt/hashicorp/data
mkdir -p ${lib_directory}

# Retrieve license
http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${license_secret}" | \
  base64 --decode --ignore-garbage > ${license_file_location}

%{ if ssl_certificate_secret != null && ssl_private_key_secret != null ~}
# Retrieve SSL certificate
http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${ssl_certificate_secret}" | \
  base64 --decode --ignore-garbage > ${ssl_certificate_pathname}

# Retrieve SSL private key
http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${ssl_private_key_secret}" | \
  base64 --decode --ignore-garbage > ${ssl_private_key_pathname}
%{ endif ~}

%{ if airgap_url != "" ~}
# Retrieve airgap config
http_proxy="" https_proxy="" gsutil cp ${airgap_url} ${airgap_pathname}
%{ endif ~}

%{ if monitoring_enabled ~}
# Install monitoring
curl -sS -o /tmp/add-monitoring-agent-repo.sh https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
bash /tmp/add-monitoring-agent-repo.sh
if [[ $distribution == "ubuntu" ]]
then
  apt-get -y update
  apt-get -y install stackdriver-agent
elif [[ $distribution == "rhel" ]]
then
  yum install -y stackdriver-agent
fi
service stackdriver-agent start
%{ endif ~}

# Install TFE
echo "[Terraform Enterprise] Setting up" | tee -a /var/log/ptfe.log
curl -o /tmp/install.sh https://get.replicated.com/docker/terraformenterprise/active-active
chmod +x /tmp/install.sh
private_ip=$(curl -H "Metadata-Flavor: Google" "http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip")
/tmp/install.sh \
  fast-timeouts \
  private-address="$private_ip" \
  public-address="$private_ip" \
  %{ if proxy_ip != "" ~}
  http-proxy="${proxy_ip}" \
  additional-no-proxy="${no_proxy}" \
  %{ else ~}
  no-proxy \
  %{ endif ~}
  %{if active_active ~}
  disable-replicated-ui \
  %{ endif ~}
  | tee -a /var/log/ptfe.log
