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

%{ if proxy_cert != "" ~}
if [[ $distribution == "ubuntu" ]]
then
  mkdir -p /usr/local/share/ca-certificates/extra
  cert_pathname="/usr/local/share/ca-certificates/extra/cust-ca-certificates.crt"
  # The installed version of gsutil does not support no_proxy
  # https://github.com/GoogleCloudPlatform/gsutil/issues/1178
  http_proxy="" https_proxy="" gsutil cp "gs://${bucket_name}/${proxy_cert}" $${cert_pathname}
  update-ca-certificates
  apt-get -y update
  apt-get -y install jq
elif [[ $distribution == "rhel" ]]
then
  mkdir -p /usr/share/pki/ca-trust-source/anchors
  cert_pathname="/usr/share/pki/ca-trust-source/anchors/cust-ca-certificates.crt"
  # The installed version of gsutil does not support no_proxy
  # https://github.com/GoogleCloudPlatform/gsutil/issues/1178
  http_proxy="" https_proxy="" gsutil cp "gs://${bucket_name}/${proxy_cert}" $${cert_pathname}
  update-ca-trust
  yum -y install jq
fi
%{ endif ~}
%{ endif ~}

mkdir -p /etc/docker
mkdir -p /opt/hashicorp/data

# Provision settings
echo "${settings}" | base64 -d > /etc/ptfe-settings.json
echo "${replicated}" | base64 -d > /etc/replicated.conf
echo "${docker_config}" | base64 -d > /etc/docker/daemon.json
%{ if proxy_ip != "" && proxy_cert != "" ~}
jq ". + { ca_certs: { value: \"$(cat $${cert_pathname})\" } }" -- /etc/ptfe-settings.json > ptfe-settings.json.updated
cp ./ptfe-settings.json.updated /etc/ptfe-settings.json
%{ endif ~}

# Retrieve license
http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${license_secret}" | \
  base64 --decode --ignore-garbage > ${license_file_location}

%{ if airgap_url != "" ~}
# Retrieve airgap config
http_proxy="" https_proxy="" gsutil cp ${airgap_url} /var/lib/ptfe/ptfe.airgap
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
