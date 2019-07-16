#!/bin/bash

MASTER_VM_IP=$(openstack server list | grep master | awk '{print $9}')

echo "User-data: check YOUR-NODE-IP"
ssh -i ~/.ssh/openstack_tmp centos@${MASTER_VM_IP} -t "sudo cat /var/lib/cloud/instance/user-data.txt"

