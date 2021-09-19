#!/bin/bash

printenv | sort

yq eval '.image.tag = "dev-202109192228"' backend-charts/api/values.yaml > backend-charts/api/values2.yaml

cat backend-charts/api/values2.yaml