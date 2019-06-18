#!/usr/bin/env bash

echo kubectl create clusterrolebinding default-sa-cluster-admin --clusterrole=cluster-admin --serviceaccount default:default
kubectl create clusterrolebinding default-sa-cluster-admin --clusterrole=cluster-admin --serviceaccount default:default

echo kubectl describe clusterrolebinding default-sa-cluster-admin
kubectl describe clusterrolebinding default-sa-cluster-admin
