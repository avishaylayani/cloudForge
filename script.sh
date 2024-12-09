#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Automate the provisioning, configuration, and lifecycle management of cloud infrastructure using Terraform and Ansible.
# Version: 3.2.5
# Date: 03/11/2024
#########################################################################
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print success message
function print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print error message
function print_error() {
    echo -e "${RED}$1${NC}"
}

# Function to print information message
function print_info() {
    echo -e "${CYAN}$1${NC}"
}

# Trap to handle any errors
trap 'print_error "Error: Something went wrong at stage: $CURRENT_STAGE"' ERR

# Set current stage variable
CURRENT_STAGE=""

# Navigate to the terraform directory
CURRENT_STAGE="Navigate to Terraform directory"
cd terraform
# terraform destroy --auto-approve >> /dev/null
# echo "Terraform destroyed successfully"
# terraform init >> /dev/null
# echo "INit worked fine"
# terraform fmt >> /dev/null
# echo "fmt worked fine"
# echo ""
# echo ""

terraform apply --auto-approve >> /dev/null
OUTPUT=$(terraform output -raw instance_ssh_command)

# Echo the output and pipe it into read method
echo "$OUTPUT" | while read -r line; do
    echo $line
done


for i in $(echo $OUTPUT_VALUE); do
    echo $i
done
cd ..

python3 scripts/parse_inventory.py >> /dev/null
echo "Script to create inventory worked fine"
cd ansible

ansible-playbook main.yml 
echo "Ansible worked fine"