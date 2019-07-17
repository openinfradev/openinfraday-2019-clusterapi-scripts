#!/bin/bash

echo "check openstack VMs"
openstack server list
echo "Done"

echo "check pivot"
echo "check kubernetes namespaces"
MASTER_VM_IP=$(openstack server list | grep master | awk '{print $9}')
ssh -i ~/.ssh/openstack_tmp centos@${MASTER_VM_IP} -t "sudo kubectl get namespaces"
echo "Done"

echo "check clusterapi-controller pod"
ssh -i ~/.ssh/openstack_tmp centos@${MASTER_VM_IP} -t "sudo kubectl get pods -n openstack-provider-system"
echo "Done"
