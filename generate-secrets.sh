#!/bin/bash

set -e

echo "INFO: converting secrets to base64"
access_key=$(echo -n "$DC_AWS_ACCESS_KEY" | base64 | tr -d '\n')
secret_key=$(echo -n "$DC_AWS_SECRE_KEY" | base64 | tr -d '\n')

echo "INFO: generating template secrets file"s
cat << 'EOF' >> ./secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: awscredentials
  namespace: autobots
type: Opaque
data:
EOF

echo "INFO: storing secrets in the file"
echo "  access-key: $access_key" >> secrets.yaml
echo "  secret-key: $secret_key" >> secrets.yaml

unset $access_key
unset $secret_key

echo "INFO: replacing secrets"
kubectl apply -f secrets.yaml