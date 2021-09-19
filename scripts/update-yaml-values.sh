#!/bin/bash

printenv | sort

yq eval '.image.tag = $IMAGE_TAG' backend-charts/api/values.yaml > backend-charts/api/values2.yaml

cat backend-charts/api/values2.yaml