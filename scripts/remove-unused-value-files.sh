#!/bin/bash

mkdir turn-based-api-chart
cp -r backend-charts/api/* turn-based-api-chart

echo 'list files'
ls

rm -v !("turn-based-api-chart/$HELM_VALUE_PATH")
mv "turn-based-api-chart/$HELM_VALUE_PATH" "turn-based-api-chart/values.yaml"

helm package turn-based-api-chart/*
helm repo index --url https://github.com/johnchan2016/turn-based-helm-chart.git .

echo '***** get content of index.yaml *****' 
cat index.yaml
git add . && \
git commit -m "create helm chart for version $IMAGE_TAG" && \
git push origin master