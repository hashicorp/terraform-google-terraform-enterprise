Host default
    HostName ${instance.network_ip}
    User ${user}
    Port 22
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no
    IdentityFile ${identity_file}
    IdentitiesOnly yes
    LogLevel FATAL
    ProxyCommand gcloud compute start-iap-tunnel ${instance.name} 22 --listen-on-stdin --verbosity=warning --project=${instance.project} --zone=${instance.zone}
