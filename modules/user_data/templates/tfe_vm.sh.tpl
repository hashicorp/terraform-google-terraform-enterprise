#!/usr/bin/env bash
set -e -u -o pipefail

log_pathname="/var/log/ptfe.log"
echo "[Terraform Enterprise] Setting up" | tee -a $log_pathname

release_name=$(grep "^NAME=" /etc/os-release | cut -d"\"" -f2)

echo "[Terraform Enterprise] Detected operating system release name: '$release_name'" | tee -a $log_pathname

case "$release_name" in
  "Red Hat"*)
    distribution="rhel"
    ;;
  "Ubuntu"*)
    distribution="ubuntu"
    ;;
  *)
    echo "[Terraform Enterprise] Unsupported operating system release in use; exiting" | tee -a $log_pathname
    exit 1
esac
echo "[Terraform Enterprise] Assuming distribution: '$distribution'" | tee -a $log_pathname

if [[ $distribution == "rhel" ]]
then
  echo "[Terraform Enterprise] Patching GCP Yum repo configuration" | tee -a $log_pathname
  # workaround for GCP RHEL 7 known issue 
  # https://cloud.google.com/compute/docs/troubleshooting/known-issues#keyexpired
  sed -i 's/repo_gpgcheck=1/repo_gpgcheck=0/g' /etc/yum.repos.d/google-cloud.repo
  yum makecache fast
fi

echo "[Terraform Enterprise] Writing Terraform Enterprise settings to '${settings_pathname}'" | tee -a $log_pathname
echo "${settings}" | base64 --decode > ${settings_pathname}

replicated_conf_pathname="/etc/replicated.conf"
echo "[Terraform Enterprise] Writing Replicated configuration to '$replicated_conf_pathname'" | tee -a $log_pathname
echo "${replicated}" | base64 --decode > $replicated_conf_pathname

docker_directory="/etc/docker"
echo "[Terraform Enterprise] Creating Docker directory at '$docker_directory'" | tee -a $log_pathname
mkdir -p $docker_directory
docker_daemon_pathname="$docker_directory/daemon.json"
echo "[Terraform Enterprise] Writing Docker daemon to '$docker_daemon_pathname'" | tee -a $log_pathname
echo "${docker_config}" | base64 --decode > $docker_daemon_pathname

%{ if http_proxy_uri_authority != null ~}
environment_pathname="/etc/environment"
echo "[Terraform Enterprise] Configuring environment proxy in '$environment_pathname'" | tee -a $log_pathname
/bin/cat <<EOF >>$environment_pathname
http_proxy="http://${http_proxy_uri_authority}"
https_proxy="https://${http_proxy_uri_authority}"
no_proxy="${no_proxy}"
EOF

profile_proxy_pathname="/etc/profile.d/proxy.sh"
echo "[Terraform Enterprise] Configuring profile proxy in '$profile_proxy_pathname'" | tee -a $log_pathname
/bin/cat <<EOF >$profile_proxy_pathname
http_proxy="http://${http_proxy_uri_authority}"
https_proxy="https://${http_proxy_uri_authority}"
no_proxy="${no_proxy}"
EOF

export http_proxy="http://${http_proxy_uri_authority}"
export https_proxy="https://${http_proxy_uri_authority}"
export no_proxy="${no_proxy}"

%{ endif ~}
%{ if ca_certificate_secret != null ~}
ca_certificate_directory="/dev/null"

if [[ $distribution == "ubuntu" ]]
then
  ca_certificate_directory="/usr/local/share/ca-certificates/extra"
elif [[ $distribution == "rhel" ]]
then
  ca_certificate_directory="/usr/share/pki/ca-trust-source/anchors"
fi

echo "[Terraform Enterprise] Creating CA certificate directory at '$ca_certificate_directory'" | tee -a $log_pathname
mkdir --parents "$ca_certificate_directory"

echo "[Terraform Enterprise] Reading CA certificate secret '${ca_certificate_secret}'" | tee -a $log_pathname
certificate_data="$( \
  http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${ca_certificate_secret}" | \
    base64 --decode --ignore-garbage \
)"

ca_certificate_pathname="$ca_certificate_directory/tfe-ca-certificate.crt"
echo "[Terraform Enterprise] Writing CA certificate data to '$ca_certificate_pathname'" | tee -a $log_pathname
echo "$certificate_data" > $ca_certificate_pathname

echo "[Terraform Enterprise] Updating CA certificates" | tee -a $log_pathname
if [[ $distribution == "ubuntu" ]]
then
  update-ca-certificates
elif [[ $distribution == "rhel" ]]
then
  update-ca-trust
fi

echo "[Terraform Enterprise] Installing jq" | tee -a $log_pathname
if [[ $distribution == "ubuntu" ]]
then
  apt-get --assume-yes update
  apt-get --assume-yes install jq
  apt-get --assume-yes autoremove
elif [[ $distribution == "rhel" ]]
then
  yum --assumeyes install jq
fi

original_settings_pathname="/etc/ptfe-settings-original.json"
echo "[Terraform Enterprise] Copying Terraform Enterprise settings to '$original_settings_pathname'" | tee -a $log_pathname
cp ${settings_pathname} $original_settings_pathname
echo "[Terraform Enterprise] Adding CA certificate data as 'ca_certs' in '${settings_pathname}'" | tee -a $log_pathname
jq ". + { ca_certs: { value: \"$certificate_data\" } }" -- $original_settings_pathname > ${settings_pathname}

%{ endif ~}
%{ if disk_path != null ~}
device="/dev/${disk_device_name}"
echo "[Terraform Enterprise] Checking disk at '$device' for EXT4 filesystem" | tee -a $log_pathname

if lsblk --fs $device | grep ext4
then
  echo "[Terraform Enterprise] EXT4 filesystem detected on disk at '$device'" | tee -a $log_pathname
else
  echo "[Terraform Enterprise] Creating EXT4 filesystem on disk at '$device'" | tee -a $log_pathname

  mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard $device
fi

echo "[Terraform Enterprise] Creating mounted disk directory at '${disk_path}'" | tee -a $log_pathname
mkdir --parents ${disk_path}

echo "[Terraform Enterprise] Mounting disk '$device' to directory at '${disk_path}'" | tee -a $log_pathname
mount --options discard,defaults $device ${disk_path}
chmod og+rw ${disk_path}

echo "[Terraform Enterprise] Configuring automatic mounting of '$device' to directory at '${disk_path}' on reboot" | tee -a $log_pathname
echo "UUID=$(lsblk --noheadings --output uuid $device) ${disk_path} ext4 discard,defaults 0 2" >> /etc/fstab

%{ endif ~}
echo "[Terraform Enterprise] Creating Terraform Enterprise library directory at '${lib_directory}'" | tee -a $log_pathname
mkdir -p ${lib_directory}

echo "[Terraform Enterprise] Writing data of license secret '${license_secret}' to '${license_file_location}'" | tee -a $log_pathname
http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${license_secret}" | \
  base64 --decode --ignore-garbage > ${license_file_location}

%{ if ssl_certificate_secret != null ~}
echo "[Terraform Enterprise] Writing data of SSL certificate secret '${ssl_certificate_secret}' to '${ssl_certificate_pathname}'" | tee -a $log_pathname
http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${ssl_certificate_secret}" | \
  base64 --decode --ignore-garbage > ${ssl_certificate_pathname}

%{ endif ~}
%{ if ssl_private_key_secret != null ~}
echo "[Terraform Enterprise] Writing data of SSL private key secret '${ssl_private_key_secret}' to '${ssl_private_key_pathname}'" | tee -a $log_pathname
http_proxy="" https_proxy="" gcloud secrets versions access latest --secret="${ssl_private_key_secret}" | \
  base64 --decode --ignore-garbage > ${ssl_private_key_pathname}

%{ endif ~}
%{ if monitoring_enabled ~}
monitoring_agent_url="https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh"
monitoring_agent_pathname="/tmp/add-monitoring-agent-repo.sh"
echo "[Terraform Enterprise] Downloading Cloud Monitoring agent script from '$monitoring_agent_url' to '$monitoring_agent_pathname'" | tee -a $log_pathname
curl -sS -o $monitoring_agent_pathname $monitoring_agent_url

echo "[Terraform Enterprise] Executing Cloud Monitoring agent script at '$monitoring_agent_pathname'" | tee -a $log_pathname
chmod +x $monitoring_agent_pathname
bash $monitoring_agent_pathname

echo "[Terraform Enterprise] Installing Cloud Monitoring agent" | tee -a $log_pathname
if [[ $distribution == "ubuntu" ]]
then
  apt-get --assume-yes update
  apt-get --assume-yes install stackdriver-agent
  apt-get --assume-yes autoremove
elif [[ $distribution == "rhel" ]]
then
  yum install --assumeyes stackdriver-agent
fi

echo "[Terraform Enterprise] Starting Cloud Monitoring agent service" | tee -a $log_pathname
service stackdriver-agent start
%{ endif ~}

echo "[Terraform Enterprise] Reading private IP address of compute instance from Metadata service" | tee -a $log_pathname
private_ip=$(curl -H "Metadata-Flavor: Google" "http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip")

replicated_directory="/tmp/replicated"
install_pathname="$replicated_directory/install.sh"
%{ if airgap_url != null ~}
echo "[Terraform Enterprise] Installing Docker Engine from Repository" | tee -a $log_pathname
if [[ $distribution == "ubuntu" ]]
then
  apt-get --assume-yes update
  apt-get --assume-yes install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  curl --fail --silent --show-error --location https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor --output /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get --assume-yes update
  apt-get --assume-yes install docker-ce docker-ce-cli containerd.io
  apt-get --assume-yes autoremove
elif [[ $distribution == "rhel" ]]
then
  yum install --assumeyes yum-utils
  yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
  yum install --assumeyes docker-ce docker-ce-cli containerd.io
fi
replicated_filename="replicated.tar.gz"
replicated_url="https://s3.amazonaws.com/replicated-airgap-work/$replicated_filename"
replicated_pathname="$replicated_directory/$replicated_filename"
echo "[Terraform Enterprise] Downloading Replicated from '$replicated_url' to '$replicated_pathname'" | tee -a $log_pathname
curl --create-dirs --output "$replicated_pathname" "$replicated_url"
echo "[Terraform Enterprise] Extracting Replicated in '$replicated_directory'" | tee -a $log_pathname
tar --directory "$replicated_directory" --extract --file "$replicated_pathname"

echo "[Terraform Enterprise] Copying airgap package '${airgap_url}' to '${airgap_pathname}'" | tee -a $log_pathname
curl --create-dirs --output "${airgap_pathname}" "${airgap_url}"

%{ else ~}
install_url="https://get.replicated.com/docker/terraformenterprise/active-active"
echo "[Terraform Enterprise] Downloading Replicated installation script from '$install_url' to '$install_pathname'" | tee -a $log_pathname
curl --create-dirs --output $install_pathname $install_url

%{ endif ~}
echo "[Terraform Enterprise] Executing Replicated installation script at '$install_pathname'" | tee -a $log_pathname
chmod +x $install_pathname
cd $replicated_directory
$install_pathname \
  fast-timeouts \
  private-address="$private_ip" \
  public-address="$private_ip" \
  %{ if http_proxy_uri_authority != null ~}
  http-proxy="${http_proxy_uri_authority}" \
  additional-no-proxy="${no_proxy}" \
  %{ else ~}
  no-proxy \
  %{ endif ~}
  %{if enable_active_active ~}
  disable-replicated-ui \
  %{ endif ~}
  %{ if airgap_url != null ~}
  airgap \
  %{ endif ~}
  | tee -a $log_pathname

%{ if custom_image_tag != null ~}
%{ if length(regexall("^.+-docker\\.pkg\\.dev|^.*\\.?gcr\\.io", custom_image_tag)) > 0 ~}
echo "[Terraform Enterprise] Registering gcloud as a Docker credential helper" | tee -a
gcloud auth configure-docker --quiet ${split("/", custom_image_tag)[0]}

%{ endif ~}
echo "[Terraform Enterprise] Pulling custom worker image '${custom_image_tag}'" | tee -a
docker pull ${custom_image_tag}
%{ endif ~}
