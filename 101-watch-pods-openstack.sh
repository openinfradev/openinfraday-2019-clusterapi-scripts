#!/bin/bash
set -x
watch "kubectl get pods -n openstack | grep -v Com"
