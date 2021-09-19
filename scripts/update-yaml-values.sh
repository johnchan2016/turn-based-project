#!/bin/bash

printenv | sort

yq eval '.image.tag = "dev-202109192228"' $HELM_VALUE_PATH > $HELM_VALUE_PATH

cat $HELM_VALUE_PATH