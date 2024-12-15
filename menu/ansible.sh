#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Runs Ansible configuration for K3S in AWS
# Version: 3.2.2
# Date: 15/12/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

ansible_operations() {
    echo -e "$(colorize 'Running Ansible operations...' 'magenta')" && sleep 0.6
    
    # add permissions to files
    chmod +x scripts/parse_inventory.py
    chmod 600 terraform/main_structure/cloudforge.pem 

    # Parse inventory from terraform ec2
    python3 scripts/parse_inventory.py

    # Run the Ansible playbook
    cd ansible || exit
    ansible-playbook main.yml
    cd - > /dev/null
}