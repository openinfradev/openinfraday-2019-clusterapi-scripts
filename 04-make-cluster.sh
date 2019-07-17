#!/bin/bash

source ~/.bashrc
cd ~/

# create k8s cluster on openstack
clusterctl create cluster --bootstrap-type kind --provider openstack -c ~/cluster.yaml -m ~/machines.yaml -p ~/provider-components.yaml
