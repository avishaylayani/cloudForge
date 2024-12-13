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
terraform init >> /dev/null
echo "[+]  Init worked fine"
chmod 400 cloudforge.pem
terraform destroy --auto-approve
echo "[+]  destroyed any resources, if existed"
terraform fmt
echo "[+]  fmt worked fine, starting apply now"


terraform apply --auto-approve
OUTPUT=$(terraform output -raw instance_ssh_command)

echo "" > machines.txt
# Echo the output and pipe it into read method
echo "$OUTPUT" | while read -r line; do
    echo $line
done

cd ..
sleep 10
python3 scripts/parse_inventory.py >> /dev/null
echo "[+]  Script to create inventory worked fine"
cd ansible
sleep 10
ansible-playbook main.yml
echo "[+]  Ansible worked fine"