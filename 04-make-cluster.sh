#!/bin/bash

# create k8s cluster on openstack
cd $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack/cmd/clusterctl/examples/openstack

clusterctl create cluster --bootstrap-type kind --provider openstack -c ./out/cluster.yaml -m ./out/machines.yaml -p ./out/provider-components.yaml
