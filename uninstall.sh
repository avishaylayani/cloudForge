#!/bin/bash

helm uninstall cert-manager --namespace cert-manager 
helm uninstall details-app-prod 
helm uninstall details-app-dev