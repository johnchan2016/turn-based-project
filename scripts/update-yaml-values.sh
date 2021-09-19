#!/bin/bash

printenv | sort

yq eval '.image.tag = $IMAGE_TAG' $HELM_VALUE_PATH > $HELM_VALUE_PATH

cat $HELM_VALUE_PATH