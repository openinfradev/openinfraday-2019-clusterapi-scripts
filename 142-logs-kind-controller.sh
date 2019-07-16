#!/bin/bash

export KUBECONFIG="$(kind get kubeconfig-path --name="clusterapi")"
kubectl logs -f clusterapi-controllers-0 -n openstack-provider-system
