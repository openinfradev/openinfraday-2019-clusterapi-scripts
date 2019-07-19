#!/bin/bash

source ~/.bashrc

# create ~/clouds.yaml
echo "Create clouds.yaml..."
PROJECT_ID=$(openstack project list | grep admin | awk '{print $2}')

cat > ~/clouds.yaml <<EOF
clouds:
  taco-openstack:
    auth:
      auth_url: http://keystone.openstack.svc.cluster.local:80/v3
      project_name: admin
      username: admin
      password: password
      user_domain_name: Default
      project_domain_name: Default
      project_id: ${PROJECT_ID}
    region_name: RegionOne
EOF
echo "Done"

# user-data host IP
echo "Change user-data host IP..."
IP=$(ifconfig bond0 | grep netmask | awk '{print $2}')

cd $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack/cmd/clusterctl/examples/openstack/provider-component/user-data/centos/templates

sed -i "s/YOUR-NODE-IP/${IP}/g" master-user-data.sh
sed -i "s/YOUR-NODE-IP/${IP}/g" worker-user-data.sh
echo "Done"

# generate YAML
echo "Generate YAML files..."
cd $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack/cmd/clusterctl/examples/openstack
rm -rf out
./generate-yaml.sh -f ~/clouds.yaml taco-openstack centos
echo "Done"

# import openstack keypair
echo "Make openstack keypair..."
openstack keypair create --public-key ~/.ssh/openstack_tmp.pub cluster-api-provider-openstack
echo "Done"

# Fix machines.yaml
echo "Fix machines.yaml..."
NETWORK_UUID=$(openstack network list | grep private-net | awk '{print $2}')
SECURITY_GROUP=$(openstack security group list | grep clusterapi | awk '{print $2}')
sed -i "s/<Image Name>/CentOS-7-1905/g" out/machines.yaml
sed -i "s/<SSH Username>/centos/g" out/machines.yaml
sed -i "s/<Kubernetes Network ID>/${NETWORK_UUID}/g" out/machines.yaml
sed -i "s/<Security Group ID>/${SECURITY_GROUP}/g" out/machines.yaml
sed -i "s/1.15.0/1.14.3/g" out/machines.yaml

FLOATING_IP_1=$(openstack floating ip list | grep None | head -n 1 | awk '{print $4}')
FLOATING_IP_2=$(openstack floating ip list | grep None | head -n 2 | tail -n 1 | awk '{print $4}')
FLOATING_IP_LINENUM_1=$(cat out/machines.yaml | grep -n floatingIP | awk '{print $1}' | tr -d ':' | head -n 1)
FLOATING_IP_LINENUM_2=$(cat out/machines.yaml | grep -n floatingIP | awk '{print $1}' | tr -d ':' | tail -n 1)
sed -i "${FLOATING_IP_LINENUM_1}s/<Available Floating IP>/${FLOATING_IP_1}/" out/machines.yaml
sed -i "${FLOATING_IP_LINENUM_2}s/<Available Floating IP>/${FLOATING_IP_2}/" out/machines.yaml

TAGS_LINENUM_1=$(cat out/machines.yaml | grep -n tags | awk '{print $1}' | tr -d ':' | head -n 1)
if [[ ! -z "$TAGS_LINENUM_1" ]]; then
  sed -i "${TAGS_LINENUM_1},$(($TAGS_LINENUM_1+3))d" out/machines.yaml
fi
TAGS_LINENUM_2=$(cat out/machines.yaml | grep -n tags | awk '{print $1}' | tr -d ':' | tail -n 1)
if [[ ! -z "$TAGS_LINENUM_2" ]]; then
  sed -i "${TAGS_LINENUM_2},$(($TAGS_LINENUM_2+3))d" out/machines.yaml
fi

cp -f out/cluster.yaml ~/
cp -f out/machines.yaml ~/
cp -f out/provider-components.yaml ~/
echo "Done"
