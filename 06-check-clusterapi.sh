#!/bin/bash

echo "delete worker VM"
WORKER=$(openstack server list | grep node | awk '{print $4}')
openstack server delete ${WORKER}

echo "log of clusterapi-controllers"
MASTER_VM_IP=$(openstack server list | grep master | awk '{print $9}')
ssh centos@${MASTER_VM_IP} -i ~/.ssh/openstack_tmp

sudo kubectl logs -f clusterapi-controllers-0 -n openstack-provider-system
