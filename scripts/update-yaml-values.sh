#!/bin/sh
if [ env.CurrentHelmPath == '' ]
then
  yq eval '.image.tag = "${CurrentEnv}-${CurrentTimestamp}"' ./backend-charts/api/values.yaml
else
  yq eval '.image.tag = "${CurrentEnv}-${CurrentTimestamp}"' ./backend-charts/api/values-${CurrentHelmPath}.yaml
fi

cat ./backend-charts/api/values-${CurrentHelmPath}.yaml