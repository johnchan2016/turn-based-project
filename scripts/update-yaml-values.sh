#!/bin/sh

ls backend-charts/api
echo 'env.CurrentHelmPath: ${CurrentHelmPath}'

if [ env.CurrentHelmPath = "" ]
then
  yq eval '.image.tag = "${CurrentEnv}-${CurrentTimestamp}"' backend-charts/api/values.yaml
else
  path="backend-charts/api/values_${CurrentHelmPath}.yaml"
  yq eval '.image.tag = "${CurrentEnv}-${CurrentTimestamp}"' ${path}
fi

cat backend-charts/api/values-${CurrentHelmPath}.yaml