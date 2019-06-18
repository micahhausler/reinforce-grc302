#!/usr/bin/env bash

set -e

POD_NAME=$(kubectl get pod -l app=al2 -o jsonpath='{.items[0].metadata.name}')

kubectl exec -it $POD_NAME /bin/bash
