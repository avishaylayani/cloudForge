#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Runs Terraform deployment and Ansible configuration for CICD and K8S in AWS
# Version: 3.2.2
# Date: 03/11/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

cd terraform
chmod 400 cloudforge.pem
terraform destroy --auto-approve >> /dev/null
terraform init >> /dev/null
echo "INit worked fine"
terraform fmt >> /dev/null
echo "fmt worked fine"


terraform apply --auto-approve >> /dev/null
OUTPUT=$(terraform output -raw instance_ssh_command)

# Echo the output and pipe it into read method
echo "$OUTPUT" | while read -r line; do
    echo $line
done

cd ..

python3 scripts/parse_inventory.py >> /dev/null
echo "Script to create inventory worked fine"
cd ansible

ansible-playbook main.yml 
echo "Ansible worked fine"