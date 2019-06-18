#!/usr/bin/env bash

echo kubectl describe serviceaccount default
kubectl describe serviceaccount default

echo
echo SECRET_NAME=\$\(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}'\)
SECRET_NAME=$(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}')

echo
echo kubectl describe secret $SECRET_NAME
kubectl describe secret $SECRET_NAME

echo
echo "kubectl get secret $SECRET_NAME -o jsonpath='{.data.token}' | base64 --decode | tr '.' '\n' |head -n 2 | base64 --decode | jq ."
kubectl get secret $SECRET_NAME -o jsonpath='{.data.token}' | base64 --decode | tr '.' '\n' |head -n 2 | base64 --decode | jq .
