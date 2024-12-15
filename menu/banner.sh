#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: The banner that is use in the menu
# Version: 3.2.2
# Date: 15/12/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

banner() {
clear
echo -e "\n$(colorize ' ██████╗██╗      ██████╗ ██╗   ██╗██████╗ ███████╗ ██████╗ ██████╗  ██████╗ ███████╗' 'light_blue')"
echo -e "$(colorize '██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝ ██╔════╝' 'light_blue')"
echo -e "$(colorize '██║     ██║     ██║   ██║██║   ██║██║  ██║█████╗  ██║   ██║██████╔╝██║  ███╗█████╗  ' 'light_blue')"
echo -e "$(colorize '██║     ██║     ██║   ██║██║   ██║██║  ██║██╔══╝  ██║   ██║██╔══██╗██║   ██║██╔══╝  ' 'light_blue')"
echo -e "$(colorize '╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝██║     ╚██████╔╝██║  ██║╚██████╔╝███████╗' 'light_blue')"
echo -e "$(colorize ' ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝' 'light_blue')"
echo -e "$(colorize '                                                                                    ' 'light_blue')"
echo -e "$(colorize '           ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗               ' 'light_blue')"
echo -e "$(colorize '           ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝               ' 'light_blue')"
echo -e "$(colorize '           ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║                  ' 'light_blue')"
echo -e "$(colorize '           ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║                  ' 'light_blue')"
echo -e "$(colorize '           ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║                  ' 'light_blue')"
echo -e "$(colorize '           ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝                  ' 'light_blue')\n"
}