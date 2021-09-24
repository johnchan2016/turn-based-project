#!/bin/bash

if [ -d "$HUDSON_HOME/workspace/turn-based-helm-chart" ] 
then
    rm -rf "$HUDSON_HOME/workspace/turn-based-helm-chart"
    ls
    HELM_CHART_HOME="$HUDSON_HOME/workspace/turn-based-helm-chart"
fi