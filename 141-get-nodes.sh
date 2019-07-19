#!/bin/bash

cd ~/
# export KUBECONFIG="$(kind get kubeconfig-path --name="clusterapi")"
kubectl get nodes --kubeconfig kubeconfig
