#!/bin/bash

MASTER_VM_IP=$(openstack server list | grep master | awk '{print $9}')
ssh centos@${MASTER_VM_IP} -i ~/.ssh/openstack_tmp

echo "log of cloud-init"
sudo tail -f /var/log/cloud-init.log
