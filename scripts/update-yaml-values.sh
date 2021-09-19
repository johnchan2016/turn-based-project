#!/bin/bash

printenv | sort

yq eval '.image.tag = "dev-202109192228"' $HELM_VALUE_PATH > backend-charts/api/values-new.yaml

echo 'values-new.yaml'
cat backend-charts/api/values-new.yaml

rm $HELM_VALUE_PATH

mv backend-charts/api/values-new.yaml $HELM_VALUE_PATH

echo 'backend-charts/api/values-new.yaml'
cat $HELM_VALUE_PATH