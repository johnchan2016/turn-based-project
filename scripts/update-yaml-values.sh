#!/bin/bash

printenv | sort
echo $CurrentHelmPath

if [[ -z "$CurrentHelmPath" ]]
then
  yq eval '.image.tag = $CurrentEnv-$CurrentTimestamp' backend-charts/api/values.yaml > backend-charts/api/values.yaml

  cat backend-charts/api/values.yaml
else
  path="backend-charts/api/values_$CurrentHelmPath.yaml"
  yq eval '.image.tag = $CurrentEnv-$CurrentTimestamp' $path > $path

  cat $path
fi