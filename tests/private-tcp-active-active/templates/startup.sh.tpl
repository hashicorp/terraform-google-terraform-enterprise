#!/bin/bash

set -e -u -o pipefail

# Set intial start time - used to calculate total time
SECONDS=0 #Start Time

confdir="/etc/mitmproxy"

mkdir -p $confdir

service="/etc/systemd/system/mitmproxy.service"

touch $service
chown root:root $service
chmod 0644 $service

cat <<EOF >$service
[Unit]
Description=mitmproxy
ConditionPathExists=$confdir
[Service]
ExecStart=/usr/local/bin/mitmdump -p ${http_proxy_port} --set confdir=$confdir
Restart=always
[Install]
WantedBy=multi-user.target
EOF

echo "[$(date +"%FT%T")]  Downloading mitmproxy tar from the web"
curl -Lo /tmp/mitmproxy.tar.gz https://snapshots.mitmproxy.org/6.0.2/mitmproxy-6.0.2-linux.tar.gz
tar xvf /tmp/mitmproxy.tar.gz -C /usr/local/bin/

echo "[$(date +"%FT%T")]  Deploying certificates for mitmproxy"
certificate="$confdir/mitmproxy-ca.pem"
gcloud secrets versions access latest --secret ${certificate_secret_id} | base64 --decode | tee $certificate
gcloud secrets versions access latest --secret ${private_key_secret_id} | base64 --decode | tee --append $certificate

echo "[$(date +"%FT%T")]  Starting mitmproxy service"
systemctl daemon-reload
systemctl start mitmproxy
systemctl enable mitmproxy

duration=$SECONDS #Stop Time
echo "[$(date +"%FT%T")]  Finished mitmproxy startup script."
echo "  $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
