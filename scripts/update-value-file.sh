#!/bin/bash

yq eval '.image.tag = env(IMAGE_TAG)' $HELM_VALUE_PATH > backend-charts/api/new.yaml

# echo 'remove old & replace new'
# rm $HELM_VALUE_PATH
# mv backend-charts/api/new.yaml $HELM_VALUE_PATH

find . -type f -name 'values*.yaml' -delete
mv "new.yaml" "values.yaml"

cp backend-charts/api/* $HUDSON_HOME/workspace/temp/api