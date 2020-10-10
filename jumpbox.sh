#!/usr/bin/env bash

# Copyright 2020 HCL 
#


# Variables
export PROJECT=$(gcloud config get-value project)
export WORK_DIR=${WORK_DIR:="${PWD}/workdir"}

## Install Tools
mkdir -p $WORK_DIR/bin

echo "### "
echo "### Begin Tools install"
echo "### "

## Install google cloud DSK
if command -v gcloud 2>/dev/null; then
        echo "gcloud already installed."
else
        echo "Installing google-cloud-sdk..."
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
        sudo apt-get install apt-transport-https ca-certificates gnupg
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
        #sudo apt-get install google-cloud-sdk
        sudo apt-get update && sudo apt-get install google-cloud-sdk
        echo " login to GCP project"
        gcloud init
       #        sudo mv /usr/bin/gcloud $WORK_DIR/bin
fi

## Install govc
if command -v govc 2>/dev/null; then
        echo "gove already installed."
else
        echo "Installing govc..."
        curl -sLO https://github.com/vmware/govmomi/releases/download/v0.19.0/govc_linux_amd64.gz
        gzip -d govc_linux_amd64.gz
        sudo chmod +x govc_linux_amd64
        sudo mv govc_linux_amd64 /usr/local/bin/govc
        echo "Govc Installation completed."
fi

## Install terraform

if command -v terraform 2>/dev/null; then
        echo "terraform already installed."
else
        echo "Installing terraform..."
        sudo apt-get install unzip
        curl -sLO https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
        sudo unzip terraform_0.11.14_linux_amd64.zip
        sudo chmod +x terraform
        sudo mv terraform /usr/local/bin
        echo "Terraform installation completed."
fi

