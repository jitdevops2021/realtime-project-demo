#!/bin/bash

set -x -o errexit -o pipefail

# generate kubeconfig
echo "Generating kubeconfig for ${eks_cluster_name}"
az aks get-credentials \
    --name "${eks_cluster_name}" \
    --resource-group "${aws_region}" \
    --file "${KUBECONFIG}"

echo "KUBECONFIG saved to ${KUBECONFIG}"
