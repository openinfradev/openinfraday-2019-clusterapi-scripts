#!/bin/bash

# create ~/clouds.yaml
PROJECT_ID=$(openstack project list | grep admin | awk '{print $2}')

cat >> ~/clouds.yaml <<EOF
clouds:
  taco-openstack:
    auth:
      auth_url: http://keystone.openstack.svc.cluster.local:80/v3
      project_name: admin
      username: admin
      password: password
      user_domain_name: Default
      project_domain_name: Default
      project_id: <PROJECT_ID>
    region_name: RegionOne
EOF

sed 's/<PROJECT_ID>/$PROJECT_ID' ~/clouds.yaml


# user-data host IP
IP=$(ifconfig bond0 | grep netmask | awk '{print $2}')

cd $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack/cmd/clusterctl/examples/openstack/provider-component/user-data/centos/templates

sed 's/YOUR-NODE-IP/$IP/g' master-user-data.sh
sed 's/YOUR-NODE-IP/$IP/g' worker-user-data.sh


# generate YAML
cd $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack/cmd/clusterctl/examples/openstack
./generate-yaml.sh -f ~/clouds.yaml taco-openstack centos


# import openstack keypair
openstack keypair create --public-key ~/.ssh/openstack_tmp.pub cluster-api-provider-openstack


# correct machines.yaml
NETWORK_UUID=$(openstack network list | grep private-net | awk '{print $2}')
FLOATING_IP=$(openstack floating ip list)
SECURITY_GROUP=$(openstack security group list | grep clusterapi | awk '{print $2}')

sed 's/'
sed
