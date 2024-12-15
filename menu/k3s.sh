#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Runs K3S in AWS
# Version: 3.2.2
# Date: 15/12/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

k3s() {
    # Check for master_ip file
    if [[ ! -f ansible/master_ip ]]; then
        echo -e "$(colorize 'Error: master_ip file not found!' 'red')"
        sleep 1
        return 1
    else
        K3S_MASTER_IP=$(cat ansible/master_ip)
        export K3S_MASTER_IP  # Make K3S_MASTER_IP globally available
        echo -e "$(colorize "Using master IP: $K3S_MASTER_IP" 'magenta')"
        sleep 1
    fi

    # Check for SSH key file and fix permissions if needed
    if [[ ! -f terraform/main_structure/cloudforge.pem ]]; then
        echo -e "$(colorize 'Error: ssh key file not found!' 'red')" && sleep 0.6
        return 1
    else
        # Check file permissions in a cross-platform way
        if [[ $(stat -f "%A" terraform/main_structure/cloudforge.pem) != "600" ]]; then
            chmod 600 terraform/cloudforge.pem
            echo -e "$(colorize 'Fixing ssh key permissions...' 'yellow')" && sleep 0.6
        fi
    fi

    # Set SSH key file path
    SSH_KEY_FILE="terraform/main_structure/cloudforge.pem"
    echo -e "$(colorize "SSH Key: $SSH_KEY_FILE" 'magenta')" && sleep 0.6

    # Function for executing SSH commands with error handling
    ssh_command() {
        ssh -i "$SSH_KEY_FILE" ubuntu@"$K3S_MASTER_IP" "$1"
        if [[ $? -ne 0 ]]; then
            echo -e "$(colorize 'Error: SSH command failed.' 'red')" && sleep 0.6
        fi
    }

    while true; do
        banner
        echo -e "$(colorize 'K3S Operations (Rollout & Rollback):' 'cyan')\n"
        echo -e "$(colorize '1.' 'light_green') Rollout K3S"
        echo -e "$(colorize '2.' 'light_green') Rollback K3S\n"
        echo -e "$(colorize '3.' 'light_green') kubectl get deployments"
        echo -e "$(colorize '4.' 'light_green') kubectl get pods"
        echo -e "$(colorize '5.' 'light_green') kubectl get nodes"
        echo -e "$(colorize '6.' 'light_green') kubectl get services\n"
        echo -e "$(colorize '9.' 'white') Return to Main Menu\n"
        echo -e "$(colorize '0.' 'light_red') Exit\n"
        read -rp "$(colorize 'Select an option: ' 'yellow')" OPTION

        case $OPTION in
        1) ssh_command "kubectl apply -f rollout.yaml" ;;
        2) ssh_command "kubectl rollout undo -f rollout.yaml" ;;
        3) ssh_command "kubectl get deployments" ;;
        4) ssh_command "kubectl get pods" ;;
        5) ssh_command "kubectl get nodes" ;;
        6) ssh_command "kubectl get services" ;;
        9) main_menu ;;
        0) exit ;;
        *) echo -e "$(colorize 'Invalid option. Please try again.' 'red')" ;;
        esac
        sleep 1
    done
}