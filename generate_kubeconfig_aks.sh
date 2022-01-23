#!/bin/bash

# This script requires Azure CLI version 2.25.0 or later. Check version with `az --version`.

# Modify for your environment.
# AKS_NAME: The name of your Azure Kubernetes Service
# SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant
AKS_NAME=aksdemo1
SERVICE_PRINCIPAL_NAME=aks-sp-demo
RESOURCE_GROUP=aksdevops

# Obtain the full registry ID for subsequent command args
#AKR_REGISTRY_ID=$(az aks show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query id --output tsv)

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
SP_PASSWD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --role Contributor --query password --output tsv)
SP_APP_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query [].appId --output tsv)
TENANT_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query [].tenant --output tsv)


# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $SP_APP_ID"
echo "Service principal password: $SP_PASSWD"
echo "Service principal password: $TENANT_ID"

az login --service-principal --username SP_APP_ID --password SP_PASSWD --tenant TENANT_ID

set -x -o errexit -o pipefail

# generate kubeconfig
echo "Generating kubeconfig for ${eks_cluster_name}"
az aks get-credentials \
    --name "${eks_cluster_name}" \
    --resource-group "${aws_region}" \
    --file "${KUBECONFIG}"

echo "KUBECONFIG saved to ${KUBECONFIG}"
