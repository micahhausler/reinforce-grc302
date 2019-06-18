#!/usr/bin/env bash

aws eks update-cluster-config --name eksworkshop-eksctl --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
