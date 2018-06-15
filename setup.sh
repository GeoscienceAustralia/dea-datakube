kubectl apply -f manifests/rbac-config.yaml
helm init --service-account tiller
helm install --name nginx stable/nginx-ingress --set rbac.create=true
helm install --name dc-nrt stable/postgresql

# will create dc-nrt-postgresql.default.svc.cluster.local

kubectl apply -f index/index.yaml
kubectl apply -f manifests/wms.yaml
