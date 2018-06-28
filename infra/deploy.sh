#!/bin/bash

set -e

echo "deploying $1"

export WORKSPACE=$1
terraform init -backend-config workspaces/$WORKSPACE/backend.cfg
terraform workspace new $WORKSPACE || terraform workspace select $WORKSPACE
terraform plan -input=false -var-file="workspaces/$WORKSPACE/terraform.tfvars"
terraform apply -auto-approve -input=false -var-file="workspaces/$WORKSPACE/terraform.tfvars"

rm -f cluster.yaml
rm -f secret.yaml

terraform output cluster > cluster.yaml
terraform output secret > secret.yaml
export KOPS_STATE_STORE=$(terraform output state_store)

kops create -f cluster.yaml || kops replace -f cluster.yaml
kops create secret --name $(terraform output name) sshpublickey admin -i ~/.ssh/id_rsa.pub
kops update cluster $(terraform output name) --yes