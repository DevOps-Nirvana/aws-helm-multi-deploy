#!/bin/sh
echo "\n\n--- running update-kubeconfig ---"
aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}

echo "\n\n--- caller identity ---"
aws sts get-caller-identity

cd deployment

# Creating namespace if necessary
kubectl create namespace $HELM_K8S_NAMESPACE || true

# Setup our helm args
export HELM_EXTRA_ARGS="$HELM_EXTRA_ARGS --set image.tag=$HELM_IMAGE_TAG --set global.image.tag=$HELM_IMAGE_TAG --set global.namespace=$HELM_K8S_NAMESPACE";

# Iterate through all our deployments
for CURRENT_HELM_CHART in $(ls -d */ | grep -Evi "helm_value_files|templates" | tr '/' ' '); do

  echo "Update our helm chart dependencies"
  helm dependency update $CURRENT_HELM_CHART || true

  # Discover values files
  VALUES_ENV_FILE=`find $CURRENT_HELM_CHART -name values-${HELM_ENVIRONMENT_SLUG}.yaml`
  VALUES_FILE_ARGS="-f $CURRENT_HELM_CHART/values.yaml${VALUES_ENV_FILE:+ -f $VALUES_ENV_FILE}"

  echo "\n\n--- HELM DIFF ---\n"
  helm diff upgrade --allow-unreleased --namespace $HELM_K8S_NAMESPACE $HELM_UPDIFF_EXTRA_ARGS $CURRENT_HELM_CHART ./$CURRENT_HELM_CHART \
    $VALUES_FILE_ARGS \
    $HELM_EXTRA_ARGS

  if [ "$HELM_DRY_RUN" == "false" ]; then
    echo "\n\n--- HELM UPGRADE ---\n"
    helm upgrade --install --atomic --namespace $HELM_K8S_NAMESPACE $CURRENT_HELM_CHART ./$CURRENT_HELM_CHART \
      $VALUES_FILE_ARGS \
      $HELM_EXTRA_ARGS;
  fi
done
