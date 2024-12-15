#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Colors for menu
# Version: 3.2.2
# Date: 15/12/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

colorize() {
    local text=$1
    local color=$2

    case $color in
        "red") echo -e "\033[0;31m${text}\033[0m" ;;
        "light_red") echo -e "\033[1;31m${text}\033[0m" ;;
        "green") echo -e "\033[0;32m${text}\033[0m" ;;
        "light_green") echo -e "\033[1;32m${text}\033[0m" ;;
        "yellow") echo -e "\033[1;33m${text}\033[0m" ;;
        "blue") echo -e "\033[0;34m${text}\033[0m" ;;
        "light_blue") echo -e "\033[1;34m${text}\033[0m" ;;
        "cyan") echo -e "\033[0;36m${text}\033[0m" ;;
        "magenta") echo -e "\033[0;35m${text}\033[0m" ;;
        "orange") echo -e "\033[0;91m${text}\033[0m" ;;
        "gray") echo -e "\033[0;90m${text}\033[0m" ;;
        "white") echo -e "\033[1;37m${text}\033[0m" ;;
        *) echo "${text}" ;;  # Default to plain text if no color matches
    esac
}