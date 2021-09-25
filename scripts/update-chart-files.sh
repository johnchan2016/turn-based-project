#!/bin/bash

# update value.yaml
yq eval '.image.tag = env(IMAGE_TAG)' $HELM_OLD_VALUE_PATH > backend-charts/api/new_value.yaml
find backend-charts/api/ -type f -name 'values*.yaml' -delete
mv "backend-charts/api/new_value.yaml" "backend-charts/api/values.yaml"

# update Chart.yaml
yq eval '.version = env(IMAGE_TAG)' $HELM_OLD_CHART_PATH > backend-charts/api/new_chart.yaml
find backend-charts/api/ -type f -name 'Chart.yaml' -delete
mv "backend-charts/api/new_chart.yaml" "backend-charts/api/Chart.yaml"