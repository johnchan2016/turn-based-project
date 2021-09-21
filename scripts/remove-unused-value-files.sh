#!/bin/bash

mkdir turn-based-api-chart
cp -r backend-charts/api/* turn-based-api-chart

echo 'list files'
cd turn-based-api-chart
ls

find . -type f -name 'values*.txt' -delete
mv "new.yaml" "values.yaml"

echo 'list files v2'
ls
cd ..

echo 'list files v3'
ls

# helm package turn-based-api-chart/*
# helm repo index --url https://github.com/johnchan2016/turn-based-helm-chart.git .

# echo '***** get content of index.yaml *****' 
# cat index.yaml
# git add . && \
# git commit -m "create helm chart for version $IMAGE_TAG" && \
# git push origin master