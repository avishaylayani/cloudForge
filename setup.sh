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

# Update duckdns
echo url="https://www.duckdns.org/update?domains=prod-cloudforge&token=d743e5a8-5cfa-46aa-82f9-65f1969ed90d&ip=" | curl -k -o duck_prod.log -K -
echo url="https://www.duckdns.org/update?domains=dev-cloudforge&token=d743e5a8-5cfa-46aa-82f9-65f1969ed90d&ip=" | curl -k -o duck_dev.log -K -

# Getting the private key file to encrypt the values file, and create a decrypted one in the details_app helm folder
secret_key_id="62917C0D840BFB257B005527B6AC02EBC574597F"
private_key_url="https://tinyurl.com/ypm9nkwc"
workdir=/home/ubuntu/application_files
# workdir=~/cloudForge/
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

cleaning_secret_key="gpg --batch --yes --delete-secret-key $secret_key_id 2> /dev/null" # saved commadn that deletes the private key from registry - used multiple time in the script

# For BASH script, import the private key to be able to decrypt the values file & Deletes sensitive data from local (whether imported succeded or faild)
( curl -s -L $private_key_url -o $workdir/private.key  && gpg --import $workdir/private.key 2> /dev/null && rm -rf $workdir/private.key && echo "[+] importing key successfully") || \
( echo "[-] Something went wrong with importing private key, exiting" && rm -rf private.key && eval "$cleaning_secret_key" &&  exit 1 )

# Decrypting the values file, to a one with decrypted values (Removing installed private key whether decryption succeded or fails )
( sops -d $workdir/values_encrypted_dev.yaml > $workdir/details_app_dev/values.yaml && sops -d $workdir/values_encrypted_prod.yaml > $workdir/details_app_prod/values.yaml && eval "$cleaning_secret_key" && echo "[+] values file decrypted successfully") || \
( echo "[-] Something went wrong with decryption process, exiting" && eval "$cleaning_secret_key" && exit 1 )   

# kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.crds.yaml

helm repo add jetstack https://charts.jetstack.io --force-update
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.13.0 \
  --set crds.enabled=true

# Deploy details_app using Helm - deletes values file 
( helm install details-app-prod $workdir/details_app_prod && rm -rf $workdir/details_app_prod/values.yaml && echo "[+] Production Deployment succeded" && \
 helm install details-app-dev $workdir/details_app_dev && rm -rf $workdir/details_app_dev/values.yaml && echo "[+] Dev Deployment succeded" ) || \
( echo "[-] Something went wrong with installing helm chart, existing" && rm -rf $workdir/details_app/values.yaml && exit 1 )



