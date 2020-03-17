export http_proxy="${proxy_url}"
export https_proxy="${proxy_url}"
%{ if repl_cidr == "" ~}
export no_proxy=10.0.0.0/8,127.0.0.1,169.254.169.254
% { else ~}
export no_proxy=10.0.0.0/8,127.0.0.1,169.254.169.254,${repl_cidr}
%{ endif ~}
