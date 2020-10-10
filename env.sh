#!/usr/bin/env bash


# Copyright 2020 HCL
# file use to create envirement variable used by Gke-on 
# installation
#export GOVC_URL=https://[VCENTER_SERVER_ADDRESS]/sdk
echo export GOVC_URL=https://172.17.152.65/sdk >> /home/gkeadmin/.bashrc 
echo export GOVC_USERNAME=[VCENTER_SERVER_USERNAME] >> /home/gkeadmin/.bashrc
echo export GOVC_PASSWORD=[VCENTER_SERVER_PASSWORD] >> /home/gkeadmin/.bashrc
echo export GOVC_DATASTORE=[VCENTER_DATASTORE] >> /home/gkeadmin/.bashrc
echo export GOVC_DATACENTER=[VCENTER_DATACENTER] >> /home/gkeadmin/.bashrc
echo export GOVC_RESOURCE_POOL=[VCENTER_CLUSTER_NAME]/Resources/[VCENTER_RESOURCE_POOL] >> /home/gkeadmin/.bashrc
echo export GOVC_INSECURE=true >> /home/gkeadmin/.bashrc 
echo export HTTPS_PROXY=[HTTPS_PROXY] >> /home/gkeadmin/.bashrc # optional; necessary if you use a proxy
source /home/gkeadmin/.bashrc
