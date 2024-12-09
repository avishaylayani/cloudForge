#!/bin/bash

######################################################################################
# Created by Avishay & Ori
# Purpose: Script deploys details_app in a kubernetes env. using helm.
# Date: 06/10/2024
# Version: 1.0.1
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing
set -o pipefail # Return non-zero status if any part of a pipeline fails
######################################################################################

# Getting the private key file to encrypt the values file, and create a decrypted one in the details_app helm folder
secret_key_id="62917C0D840BFB257B005527B6AC02EBC574597F"
private_key_url="https://tinyurl.com/ypm9nkwc"

cleaning_secret_key="gpg --batch --yes --delete-secret-key $secret_key_id 2> /dev/null" # saved commadn that deletes the private key from registry - used multiple time in the script

# For BASH script, import the private key to be able to decrypt the values file & Deletes sensitive data from local (whether imported succeded or faild)
( curl -s -L $private_key_url -o /home/ubuntu/application_files/private.key  && gpg --import private.key 2> /dev/null && rm -rf /home/ubuntu/application_files/private.key && echo "[+] importing key successfully") || \
( echo "[-] Something went wrong with importing private key, exiting" && rm -rf private.key && eval "$cleaning_secret_key" &&  exit 1 )

# Decrypting the values file, to a one with decrypted values (Removing installed private key whether decryption succeded or fails )
( sops -d /home/ubuntu/application_files/values_encrypted_dev.yaml > /home/ubuntu/application_files/details_app_dev/values.yaml && sops -d /home/ubuntu/application_files/values_encrypted_prod.yaml > /home/ubuntu/application_files/details_app_prod/values.yaml && eval "$cleaning_secret_key" && echo "[+] values file decrypted successfully") || \
( echo "[-] Something went wrong with decryption process, exiting" && eval "$cleaning_secret_key" && exit 1 )   

# Deploy details_app using Helm - deletes values file 
( helm install details-app-prod /home/ubuntu/application_files/details_app_prod && rm -rf /home/ubuntu/application_files/details_app_prod/values.yaml && echo "[+] Production Deployment succeded" && \
 helm install details-app-dev /home/ubuntu/application_files/details_app_dev && rm -rf /home/ubuntu/application_files/details_app_dev/values.yaml && echo "[+] Dev Deployment succeded" ) || \
( echo "[-] Something went wrong with installing helm chart, existing" && rm -rf /home/ubuntu/application_files/details_app/values.yaml && exit 1 )



