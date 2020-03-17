${primary_cloud_config}

- path: /etc/ptfe/role
  owner: root:root
  permissions: "0444"
  content: "main"

- path: /etc/replicated.rli
  owner: root:root
  permissions: "0444"
  encoding: b64
  content: ${filebase64(replicated_rli)}

- path: /etc/replicated-ptfe.conf
  owner: root:root
  permissions: "0644"
  encoding: b64
  content: ${base64encode(replicated_ptfe_conf)}

## https://help.replicated.com/docs/kb/developer-resources/automate-install/
- path: /etc/replicated.conf
  owner: root:root
  permissions: "0644"
  encoding: b64
  content: ${base64encode(replicated_conf)}

%{ if airgap_package_url != "" ~}

- path: /etc/ptfe/airgap-package-url
  owner: root:root
  permissions: "0644"
  encoding: b64
  content: ${base64encode(airgap_package_url)}

- path: /etc/ptfe/airgap-installer-url
  owner: root:root
  permissions: "0644"
  encoding: b64
  content: ${base64encode(airgap_installer_url)}
%{ endif ~}
%{ if repl_cidr != "" ~}

- path: /etc/ptfe/repl-cidr
  owner: root:root
  permissions: "0644"
  encoding: b64
  content: ${base64encode(repl_cidr)}
%{ endif ~}
%{ if weave_cidr != "" ~}

- path: /etc/ptfe/weave-cidr
  owner: root:root
  permissions: "0644"
  encoding: b64
  content: ${base64encode(weave_cidr)}
%{ endif ~}
