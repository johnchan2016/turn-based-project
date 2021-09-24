#!/bin/bash

if [ -d "$HUDSON_HOME/workspace/turn-based-helm-chart/" ] 
then
    rm -rf "$HUDSON_HOME/workspace/turn-based-helm-chart"
fi