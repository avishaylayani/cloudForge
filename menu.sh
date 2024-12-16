#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Runs Terraform deployment and Ansible configuration for CICD and K8S in AWS
# Version: 3.2.2
# Date: 15/12/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

# Load scripts from the menu folder
SCRIPT_DIR="$(dirname "$0")/menu"
source "$SCRIPT_DIR/banner.sh"
source "$SCRIPT_DIR/colorize.sh"
source "$SCRIPT_DIR/dependencies.sh"
source "$SCRIPT_DIR/terraform.sh"
source "$SCRIPT_DIR/ansible.sh"
source "$SCRIPT_DIR/k3s.sh"
source "$SCRIPT_DIR/step_by_step.sh"

open_url() {
    local url=$1

    if command -v xdg-open &>/dev/null; then
        # For Linux systems with xdg-open
        xdg-open "$url"
    elif command -v open &>/dev/null; then
        # For macOS
        open "$url"
    elif command -v gnome-open &>/dev/null; then
        # For older GNOME systems
        gnome-open "$url"
    elif command -v kde-open &>/dev/null; then
        # For KDE systems
        kde-open "$url"
    elif command -v wslview &>/dev/null; then
        # For WSL (Windows Subsystem for Linux)
        wslview "$url"
    else
        # Fallback if no tool is found
        echo -e "$(colorize 'Error: Unable to find a tool to open URLs.' 'red')"
        echo -e "$(colorize 'Please manually open the following URL:' 'yellow')"
        echo "$url"
        sleep 0.6
    fi
}

# Main Menu
main_menu() {
    while true; do
        banner
        echo -e "$(colorize 'Main Menu:' 'cyan')\n"
        echo -e "$(colorize '1.' 'light_green') Check and Install Dependencies\n"
        echo -e "$(colorize '2.' 'light_green') Apply & Install Project CloudForge\n"
        echo -e "$(colorize '3.' 'light_green') K3S Operations (Rollout & Rollback)\n"
        echo -e "$(colorize '4.' 'light_green') Run Step-by-Step\n"
        echo -e "$(colorize '5.' 'light_green') Open Browser to Prod Env UR (after applying project)\n"
        echo -e "$(colorize '6.' 'light_green') Open Browser to Dev Env URL (after applying project)\n"
        echo -e "$(colorize '7.' 'light_green') Terraform Destroy\n"
        echo -e "$(colorize '0.' 'light_red') Exit\n"
        read -rp "$(colorize 'Select an option: ' 'yellow')" OPTION

        case $OPTION in
        1) check_dependencies ;;
        2) terraform_operations && ansible_operations ;;
        3) k3s ;;
        4) step_by_step_menu ;;
        5)  if [[ -z $K3S_MASTER_IP ]]; then
                echo -e "$(colorize 'Error: K3S_MASTER_IP is not set! Please run K3S setup first.' 'red')"
                sleep 0.6
            else
                echo -e "$(colorize 'Opening Prod Env URL...' 'magenta')"
                sleep 0.6
                open_url "https://prod-cloudforge.duckdns.org/"
            fi ;;
        6)  if [[ -z $K3S_MASTER_IP ]]; then
                echo -e "$(colorize 'Error: K3S_MASTER_IP is not set! Please run K3S setup first.' 'red')"
            else
                echo -e "$(colorize 'Opening Dev Env URL...' 'magenta')"
                sleep 0.6
                open_url "https://dev-cloudforge.duckdns.org/"
            fi ;;
        7) terraform_destroy ;;
        0) echo -e "$(colorize 'Exiting...' 'magenta')" && sleep 0.6 && exit ;;
        *) echo -e "$(colorize 'Invalid option. Please try again.' 'red')" ;;
        esac
        sleep 1
    done
}

# Run Main Menu
main_menu