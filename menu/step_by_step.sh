#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Runs Terraform deployment and Ansible configuration and K3S in AWS
# Version: 3.2.2
# Date: 15/12/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

step_by_step_menu() {
    while true; do
        banner
        echo -e "$(colorize 'Step-by-Step Operations:' 'cyan')\n"
        echo -e "$(colorize '1.' 'light_green') Run Terraform\n"
        echo -e "$(colorize '2.' 'light_green') Run Ansible\n"
        echo -e "$(colorize '3.' 'light_green') Destroy Terraform\n"
        echo -e "$(colorize '9.' 'white') Return to Main Menu\n"
        echo -e "$(colorize '0.' 'gray') Exit\n"
        read -rp "$(colorize 'Select an option: ' 'yellow')" OPTION

        case $OPTION in
        1) terraform_operations ;;
        2) ansible_operations ;;
        3) terraform_destroy ;;
        9) main_menu ;;
        0) exit ;;
        *) echo -e "\n$(colorize 'Invalid option. Please try again.' 'light_red')\n" ;;
        esac
        sleep 1
    done
}