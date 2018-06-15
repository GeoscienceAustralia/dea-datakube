# DataKube

Datacube on Kubernetes

## Deploy Kubernetes Cluster
`./kops.sh`

`./setup.sh`

## Deply a WMS

`helm install --name dc-nrt stable/postgresql`
- will create dc-nrt-postgresql.default.svc.cluster.local

`kubectl apply -f index/index.yaml`
`kubectl apply -f manifests/wms.yaml`

## Detailed Install instructions

1. Follow install instructions for KOPS:
   * [AWS](https://github.com/kubernetes/kops/blob/master/docs/aws.md)
   * [GCE](https://github.com/kubernetes/kops/blob/master/docs/tutorial/gce.md)

