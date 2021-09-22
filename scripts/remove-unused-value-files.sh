#!/bin/bash

mkdir turn-based-api-chart
cp -r backend-charts/api/* turn-based-api-chart

echo 'list files'
cd turn-based-api-chart

echo '**** cat new.yaml ****'
cat new.yaml

find . -type f -name 'values*.yaml' -delete
mv "new.yaml" "values.yaml"