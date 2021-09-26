#!/bin/bash

# update value.yaml
yq eval '.image.tag = env(IMAGE_TAG)' $HELM_OLD_VALUE_PATH > $HELM_NEW_VALUE_PATH
find backend-charts/api/ -type f -name 'values*.yaml' -delete
mv $HELM_NEW_VALUE_PATH "backend-charts/api/values.yaml"

# update Chart.yaml
yq eval '.appVersion = env(HELM_APP_VERSION)' $HELM_OLD_CHART_PATH > $HELM_NEW_CHART_PATH
find backend-charts/api/ -type f -name 'Chart.yaml' -delete
mv $HELM_NEW_CHART_PATH $HELM_OLD_CHART_PATH