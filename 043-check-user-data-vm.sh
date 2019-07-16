#!/bin/bash

MASTER_VM_IP=$(openstack server list | grep master | awk '{print $9}')
ssh centos@${MASTER_VM_IP} -i ~/.ssh/openstack_tmp

echo "User-data: check YOUR-NODE-IP"
sudo cat /var/lib/cloud/instance/user-data.txt
