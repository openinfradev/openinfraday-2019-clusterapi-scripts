#!/bin/bash

# export KUBECONFIG="$(kind get kubeconfig-path --name="clusterapi")"
kubectl get pods --all-namespaces
