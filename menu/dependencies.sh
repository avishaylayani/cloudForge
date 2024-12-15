#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Dependencies for project with Detect and Install specific tool based on OS
# Version: 3.2.2
# Date: 15/12/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

# Detect OS and architecture
OS_TYPE=$(uname | tr '[:upper:]' '[:lower:]')
ARCH_TYPE=$(uname -m)

# Detect OS and architecture
detect_os_arch() {
    case "$OS_TYPE" in
    "linux")
        if [[ "$ARCH_TYPE" == "x86_64" ]]; then
            echo "Linux (AMD64)"
        elif [[ "$ARCH_TYPE" == "arm64" || "$ARCH_TYPE" == "aarch64" ]]; then
            echo "Linux (ARM64)"
        else
            echo "Linux (Unknown Architecture: $ARCH_TYPE)"
        fi
        ;;
    "darwin")
        if [[ "$ARCH_TYPE" == "x86_64" ]]; then
            echo "macOS (AMD64)"
        elif [[ "$ARCH_TYPE" == "arm64" ]]; then
            echo "macOS (ARM64)"
        else
            echo "macOS (Unknown Architecture: $ARCH_TYPE)"
        fi
        ;;
    "msys" | "cygwin" | "windows")
        echo "Windows (via WSL or Native)"
        ;;
    *)
        echo "Unknown OS: $OS_TYPE"
        ;;
    esac
}

# List of required tools
REQUIRED_TOOLS=("ansible" "aws" "terraform" "python3")

# Install specific tool based on OS
install_tool() {
    local tool=$1
    case "$OS_TYPE" in
    "linux")
        case "$tool" in
        "ansible") echo -e "$(colorize 'Installing Ansible...' 'magenta')" && sleep 0.6
                sudo apt-get update && sudo apt-get install -y ansible ;;

        "aws") echo -e "$(colorize 'Installing AWS CLI...' 'magenta')" && sleep 0.6
            curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH_TYPE}.zip" -o "awscliv2.zip"
            unzip awscliv2.zip && sudo ./aws/install && rm -rf awscliv2.zip aws ;;

        "terraform") echo -e "$(colorize 'Installing Terraform...' 'magenta')" && sleep 0.6
            curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
            sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
            sudo apt-get update && sudo apt-get install -y terraform;;

        "python3") echo -e "$(colorize 'Installing Python3...' 'magenta')" && sleep 0.6
            sudo apt-get update && sudo apt-get install -y python3 python3-pip ;;
        esac ;;

    "darwin")
        case "$tool" in
        "ansible") echo -e "$(colorize 'Installing Ansible via Homebrew...' 'magenta')" && sleep 0.6
            brew install ansible ;;

        "aws") echo -e "$(colorize 'Installing AWS CLI...' 'magenta')" && sleep 0.6
            curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
            sudo installer -pkg AWSCLIV2.pkg -target && rm AWSCLIV2.pkg ;;

        "terraform") echo -e "$(colorize 'Installing Terraform via Homebrew...' 'magenta')" && sleep 0.6
            brew tap hashicorp/tap && brew install hashicorp/tap/terraform ;;

        "python3") echo -e "$(colorize 'Installing Python3 via Homebrew...' 'magenta')" && sleep 0.6
            brew install python3 ;;
        esac ;;

    "msys" | "cygwin" | "windows") echo -e "$(colorize 'Windows detected. Install dependencies manually or via WSL.' 'yellow')" && sleep 0.6 ;;

    *) echo -e "$(colorize 'Unsupported OS. Unable to install dependencies automatically.' 'red')" && sleep 0.6 ;;
    esac
}

# Menu for installing missing dependencies
install_dependencies_menu() {
    while true; do
        banner
        echo -e "$(colorize 'Install Dependencies Menu:' 'cyan')"
        echo -e "$(colorize '1.' 'light_green') Install Ansible"
        echo -e "$(colorize '2.' 'light_green') Install AWS CLI"
        echo -e "$(colorize '3.' 'light_green') Install Terraform"
        echo -e "$(colorize '4.' 'light_green') Install Python3"
        echo -e "$(colorize '9.' 'white') Return to Main Menu"
        echo -e "$(colorize '0.' 'gray') Exit"
        read -rp "$(colorize 'Select an option: ' 'yellow')" OPTION

        case $OPTION in
        1)  if command -v ansible &>/dev/null; then
                echo -e "$(colorize 'Ansible is already installed.' 'magenta')"  && sleep 0.6
            else
                install_tool "ansible"
            fi ;;
        
        2)  if command -v aws &>/dev/null; then
                echo -e "$(colorize 'AWS CLI is already installed.' 'magenta')"  && sleep 0.6
            else
                install_tool "aws"
            fi ;;

        3)  if command -v terraform &>/dev/null; then
                echo -e "$(colorize 'Terraform is already installed.' 'magenta')"  && sleep 0.6
            else
                install_tool "terraform"
            fi ;;

        4)  if command -v python3 &>/dev/null; then
                echo -e "$(colorize 'Python3 is already installed.' 'magenta')" && sleep 0.6
            else
                install_tool "python3"
            fi ;;
        9) main_menu ;;
        0) exit ;;
        *) echo -e "$(colorize 'Invalid option. Please try again.' 'red')" && sleep 0.6 ;;
        esac
        sleep 1
    done
}

# Check dependencies
check_dependencies() {
    clear
    echo -e "$(colorize 'Checking dependencies:' 'magenta')"
    ALL_INSTALLED=true
    for TOOL in "${REQUIRED_TOOLS[@]}"; do
        if command -v "$TOOL" &>/dev/null; then
            echo -e "$(colorize "[$TOOL] INSTALLED" 'light_green')" && sleep 0.2
        else
            echo -e "$(colorize "[$TOOL] MISSING" 'light_red')" && sleep 0.2
            ALL_INSTALLED=false
        fi
    done

    if $ALL_INSTALLED; then
        echo -e "$(colorize 'All dependencies are installed!' 'green')" && sleep 1
        return 0
    else
        echo -e "$(colorize 'Some dependencies are missing.' 'yellow')" && sleep 1
        install_dependencies_menu
        return 1
    fi
}