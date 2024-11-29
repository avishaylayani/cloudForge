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
terraform destroy --auto-approve
terraform init
terraform apply --auto-approve

cd ..

python3 scripts/parse_tf_2_inventory.py

cd ansible

ansible-playbook docker_installation.yaml
ansible-playbook test.yaml