#!/bin/sh

aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}
kubectl get pods
helm list
