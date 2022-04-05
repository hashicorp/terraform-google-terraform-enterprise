wget "https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip"
unzip terraform_1.1.7_linux_amd64.zip
mv terraform /usr/bin
chmod a+x /usr/bin/terraform
terraform version

wget https://github.com/terraform-linters/tflint/releases/download/v0.35.0/tflint_linux_amd64.zip
unzip tflint_linux_amd64.zip
mv tflint /usr/bin
chmod a+x /usr/bin/tflint