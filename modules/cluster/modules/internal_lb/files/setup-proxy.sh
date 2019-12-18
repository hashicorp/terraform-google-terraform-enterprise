#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y iptables-persistent netfilter-persistent

iptables -t nat -A PREROUTING -p tcp --dport 6443 -j DNAT --to-destination "${host}"
iptables -t nat -A POSTROUTING -p tcp --dport 6443 -j MASQUERADE

iptables -t nat -A PREROUTING -p tcp --dport 23010 -j DNAT --to-destination "${host}"
iptables -t nat -A POSTROUTING -p tcp --dport 23010 -j MASQUERADE

netfilter-persistent save

echo 1 > /proc/sys/net/ipv4/ip_forward

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
