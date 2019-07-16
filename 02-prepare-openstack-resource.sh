#!/bin/bash
export LC_ALL="en_US.UTF-8"
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=password
export OS_AUTH_URL=http://keystone.openstack.svc.cluster.local:80/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

# openstack security group
openstack security group create clusterapi
openstack security group rule create --ingress --protocol tcp --dst-port 6443 clusterapi
openstack security group rule create --ingress --protocol tcp --dst-port 22 clusterapi
openstack security group rule create --ingress --protocol tcp --dst-port 179 clusterapi
openstack security group rule create --ingress --protocol tcp --dst-port 3000:32767 clusterapi
openstack security group rule create --ingress --protocol tcp --dst-port 443 clusterapi
openstack security group rule create --egress clusterapi

# CentOS image upload
cd ~/
wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1905.qcow2
openstack image create 'CentOS-7-1905' --disk-format qcow2 --file ~/CentOS-7-x86_64-GenericCloud-1905.qcow2 --container-format bare --public
rm -f CentOS-7-x86_64-GenericCloud-1905.qcow2

# create 2 floating ips
openstack floating ip create public-net
openstack floating ip create public-net
