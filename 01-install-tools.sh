#!/bin/bash

cd ~/

# go install
wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.12.7.linux-amd64.tar.gz

cat >> ~/.bashrc <<EOF
export PATH=$PATH:/usr/local/go/bin:/root/go/bin
export GOPATH=$HOME/go
EOF

source ~/.bashrc


# yq install
go get gopkg.in/mikefarah/yq.v2
mv ~/go/bin/yq.v2 /usr/local/bin/yq


# clusterctl install
git clone -b taco-clusterapi https://github.com/openinfradev/cluster-api-provider-openstack.git $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack
cd $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack/
make clusterctl
rm -rf ~/go/bin/clusterctl
cp -f $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack/bin/clusterctl ~/go/bin/


# bootstraping machine tool install (kind)
cd ~/
GO111MODULE="on" go get sigs.k8s.io/kind@v0.4.0
