#!/bin/bash

source ~/.bashrc

# create k8s cluster on openstack
echo "Create k8s cluster on openstack. Do not stop..."
clusterctl create cluster --bootstrap-type kind --provider openstack -c ~/cluster.yaml -m ~/machines.yaml -p ~/provider-components.yaml
echo "Done"
