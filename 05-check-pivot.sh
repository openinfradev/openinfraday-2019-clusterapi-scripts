#!/bin/bash

echo "check openstack VMs"
openstack server list

echo "check pivot"
MASTER_VM_IP=$(openstack server list | grep master | awk '{print $9}')
ssh centos@${MASTER_VM_IP} -i ~/.ssh/openstack_tmp

sudo kubectl get namespaces
sudo kubectl get pods -n openstack-provider-system
