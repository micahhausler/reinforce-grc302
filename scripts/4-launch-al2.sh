#!/usr/bin/env bash

set -e

echo
echo kubectl apply -f manifests/al2-deployment.yaml
kubectl apply -f manifests/al2-deployment.yaml

echo
echo kubectl get pods -o wide
kubectl get pods -o wide
