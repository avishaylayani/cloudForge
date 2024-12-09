#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Installs Micro K8S
# Version: 3.2.2
# Date: 03/11/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

## Resource: https://microk8s.io/

# Install MicroK8s on Linux
sudo snap install microk8s --classic

# Check the status while Kubernetes starts
microk8s status --wait-ready

# Turn on required services



microk8s enable dashboard
microk8s enable dns
microk8s enable registry
microk8s enable istio

# Start using Kubernetes

microk8s kubectl get all --all-namespaces

# Access the Kubernetes dashboard
microk8s dashboard-proxy

# Start Kubernetes
microk8s start