#!/bin/bash

printenv | sort

yq eval '.image.tag = env(IMAGE_TAG)' $HELM_VALUE_PATH > backend-charts/api/values-new.yaml

echo 'values-new.yaml'
cat backend-charts/api/values-new.yaml

echo 'remove old & replace new'
rm $HELM_VALUE_PATH
mv backend-charts/api/values-new.yaml $HELM_VALUE_PATH

echo 'backend-charts/api/values.yaml'
cat $HELM_VALUE_PATH