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

# Get the list of resources in the Terraform state
CURRENT_STAGE="Check Terraform state"
resource_list=$(terraform state list || true)

# Check if the state file contains any resources
if [ -z "$resource_list" ]; then
    print_success "No resources found in the state. Nothing to destroy."
else
    # Print the resources found in the state
    print_info "Resources found in the state:"
    echo "$resource_list"
    print_info "Proceeding to destroy..."

    # Destroy the resources
    CURRENT_STAGE="Terraform destroy resources"
    terraform destroy --auto-approve
    print_success "Resources destroyed successfully."
fi

# Re-initialize the Terraform working directory
CURRENT_STAGE="Terraform init"
print_info "Initializing Terraform..."
terraform init
print_success "Terraform initialized successfully."

# Format the Terraform configuration files
CURRENT_STAGE="Terraform fmt"
print_info "Formatting Terraform files..."
terraform fmt
print_success "Terraform formatting completed successfully."

# Apply the Terraform configuration
CURRENT_STAGE="Terraform apply"
print_info "Applying Terraform configuration..."
terraform apply --auto-approve
print_success "Terraform applied successfully."

# Get the instance SSH command output
CURRENT_STAGE="Get instance SSH commands"
print_info "Getting SSH commands for instances..."
OUTPUT=$(terraform output -raw instance_ssh_command)
echo "$OUTPUT"

# Navigate back to the main directory
CURRENT_STAGE="Navigate to main directory"
cd ..

# Run the Python script to create the inventory
CURRENT_STAGE="Run Python inventory script"
print_info "Running the Python script to create inventory..."
python3 scripts/parse_tf_2_inventory.py
print_success "Script to create inventory worked fine."

# Navigate to the ansible directory
CURRENT_STAGE="Navigate to Ansible directory"
cd ansible

# Run the Ansible playbook
CURRENT_STAGE="Run Ansible playbook"
print_info "Running the Ansible playbook..."
ansible-playbook k3s.yml
print_success "Ansible playbook executed successfully."