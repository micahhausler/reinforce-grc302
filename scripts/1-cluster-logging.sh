#!/usr/bin/env bash

read -r -p "What is the name of your eks cluster (defaults to eksworkshop-eksctl)? " CLUSTER_NAME
CLUSTER_NAME=${CLUSTER_NAME:-eksworkshop-eksctl}

read -r -p "What is the region of your eks cluster (defaults to us-west-2)? " AWS_REGION
AWS_REGION=${AWS_REGION:-us-west-2}

echo aws \
    --region $AWS_REGION \
    eks update-cluster-config \
    --name $CLUSTER_NAME \
    --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
aws \
    --region $AWS_REGION \
    eks update-cluster-config \
    --name $CLUSTER_NAME \
    --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
