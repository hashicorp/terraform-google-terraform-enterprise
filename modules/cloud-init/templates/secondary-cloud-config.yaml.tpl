${base_cloud_config}

- path: /etc/ptfe/role
  owner: root:root
  permissions: "0444"
  content: "secondary"
