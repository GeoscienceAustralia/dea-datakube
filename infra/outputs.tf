output "cluster" {
  value = <<EOF
apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  creationTimestamp: ${timestamp()}
  labels:
    kops.k8s.io/cluster: ${var.name}
  name: master-${var.region}a
spec:
  image: ${data.aws_ami.k8s.image_id}
  machineType: ${var.master_type}
  maxSize: 1
  minSize: 1
  nodeLabels:
    kops.k8s.io/instancegroup: master-${var.region}a
  role: Master
  subnets:
  - ${var.region}a
---
apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  creationTimestamp: ${timestamp()}
  labels:
    kops.k8s.io/cluster: ${var.name}
  name: nodes
spec:
  image: ${data.aws_ami.k8s.image_id}
  machineType: ${var.node_type}
  maxSize: ${var.max_nodes}
  minSize: ${var.min_nodes}
  nodeLabels:
    kops.k8s.io/instancegroup: nodes
  role: Node
  subnets:
  - ${var.region}a
  - ${var.region}b
  - ${var.region}c
---
apiVersion: kops/v1alpha2
Kind: Cluster
metadata:
  creationTimestamp: ${timestamp()}
  name: ${var.name}
spec:
  api:
    loadBalancer:
      type: Public
  authorization:
    rbac: {}
  channel: stable
  cloudProvider: aws
  configBase: s3://${aws_s3_bucket.kubernetes_state.id}/${var.name}
  dnsZone: ${var.name}
  etcdClusters:
  - etcdMembers:
    - encryptedVolume: true
      instanceGroup: master-${var.region}a
      name: a
    name: main
  - etcdMembers:
    - encryptedVolume: true
      instanceGroup: master-${var.region}a
      name: a
    name: events
  iam:
    allowContainerRegistry: true
    legacy: false
  kubernetesApiAccess:
  - ${var.ssh_ip_address}
  kubernetesVersion: 1.9.6
  masterInternalName: api.internal.${var.name}
  masterPublicName: api.${var.name}
  networkCIDR: ${var.vpc_cidr}
  networkID: ${module.vpc.vpc_id}
  networking:
    weave: 
      mtu: 8912
  nonMasqueradeCIDR: 100.64.0.0/10
  sshAccess:
  - ${var.ssh_ip_address}
  subnets:
  - cidr: ${element(var.private_subnet_cidrs, 0)}
    id: ${element(module.vpc.private_subnets, 0)}
    egress: ${element(module.public.nat_instance_ids, 0)}
    name: ${var.region}a
    type: Private
    zone: ${var.region}a
  - cidr: ${element(var.private_subnet_cidrs, 1)}
    id: ${element(module.vpc.private_subnets, 1)}
    egress: ${element(module.public.nat_instance_ids, 1)}
    name: ${var.region}b
    type: Private
    zone: ${var.region}b
  - cidr: ${element(var.private_subnet_cidrs, 2)}
    id: ${element(module.vpc.private_subnets, 2)}
    egress: ${element(module.public.nat_instance_ids, 2)}
    name: ${var.region}c
    type: Private
    zone: ${var.region}c
  - cidr: ${element(var.public_subnet_cidrs, 0)}
    id: ${element(module.vpc.public_subnets, 0)}
    name: utility-${var.region}a
    type: Utility
    zone: ${var.region}a
  - cidr: ${element(var.public_subnet_cidrs, 1)}
    id: ${element(module.vpc.public_subnets, 1)}
    name: utility-${var.region}b
    type: Utility
    zone: ${var.region}b
  - cidr: ${element(var.public_subnet_cidrs, 2)}
    id: ${element(module.vpc.public_subnets, 2)}
    name: utility-${var.region}c
    type: Utility
    zone: ${var.region}c
  topology:
    dns:
      type: Public
    masters: private
    nodes: private

EOF
}

output "secret" {
  value = <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${var.name}
type: Opaque
data:
  state-bucket: "${base64encode(aws_s3_bucket.tf_state.id)}"
  postgres-username: "${base64encode(module.db.db_username)}"
  postgres-password: "${base64encode(module.db.db_password)}"
EOF
}

output "state_store" {
  value = "s3://${aws_s3_bucket.kubernetes_state.id}"
}

output "name" {
  value = "${var.name}"
}
