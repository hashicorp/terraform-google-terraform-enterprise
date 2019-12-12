#!/bin/bash

apt-get install -y haproxy

echo '
frontend k8
    bind *:6443
    mode tcp
    option tcplog
    default_backend k8

backend k8
    mode tcp
    balance roundrobin
    %{ for i, host in hostnames ~}
    server kube${i} ${host}:6443 check
    %{ endfor ~}

frontend assist
    bind *:23010
    mode tcp
    option tcplog
    default_backend assist

backend assist
    mode tcp
    balance roundrobin
    %{ for i, host in hostnames ~}
    server kube${i} ${host}:23010 check
    %{ endfor ~}
' >> /etc/haproxy/haproxy.cfg

systemctl restart haproxy
