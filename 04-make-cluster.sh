#!/bin/bash

source ~/.bashrc
cd ~/

# create k8s cluster on openstack
echo "Create k8s cluster on openstack. Do not stop..."
clusterctl create cluster --bootstrap-cluster-kubeconfig ~/.kube/config --provider openstack -c ~/cluster.yaml -m ~/machines.yaml -p ~/provider-components.yaml
echo "Done"
