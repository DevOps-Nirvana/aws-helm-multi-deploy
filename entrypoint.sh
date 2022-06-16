#!/bin/sh
echo "\n\n--- export ---"
export

echo "\n\n--- running update-kubeconfig ---"
aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}

echo "\n\n--- kube config ---"
echo `cat ~/.kube/config`

echo "\n\n--- caller identity ---"
aws sts get-caller-identity

echo "\n\n--- get pods ---"
kubectl get pods

echo "\n\n--- helm list ---"
helm list
