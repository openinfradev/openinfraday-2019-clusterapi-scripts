#!/bin/bash

# remove kind bootstrap machine
kind get clusters
kind delete cluster --name clusterapi

# remove openstack master vm, if created
if [[ $(openstack server list | grep master) ]]; then
  echo "Removing existing master VM..."
  MASTER=$(openstack server list | grep master | awk '{print $4}')
  openstack server delete ${MASTER}
  echo "Done"
fi

# remove openstack worker vm, if created
if [[ $(openstack server list | grep node) ]]; then
  echo "Removing existing worker VM..."
  WORKER=$(openstack server list | grep node | awk '{print $4}')
  openstack server delete ${WORKER}
  echo "Done"
fi
