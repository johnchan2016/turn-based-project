#!/bin/bash

if [ -d "turn-based-helm-chart" ] 
then
    rm -rf "$HUDSON_HOME/workspace/turn-based-helm-chart"
    export HELM_CHART_HOME="$HUDSON_HOME/workspace/turn-based-helm-chart"
fi