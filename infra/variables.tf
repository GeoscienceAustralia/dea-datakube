variable "name" {
  description = "The DNS name for your cluster"
}

locals {
  cluster = "${replace(var.name, ".", "-")}"
}

variable "node_type" {
  default = "t2.medium"
}

variable "min_nodes" {
  default = 2
}

variable "max_nodes" {
  default = 6
}

variable "master_type" {
  default = "t2.micro"
}

# Networking
variable "vpc_cidr" {
  description = "VPC cidr block. Example: 172.20.0.0/16"
  default     = "172.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
  type        = "list"
  default     = ["172.20.0.0/22", "172.20.4.0/22", "172.20.8.0/22"]
}

variable "private_subnet_cidrs" {
  description = "List of private cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
  type        = "list"
  default     = ["172.20.32.0/19", "172.20.64.0/19", "172.20.96.0/19"]
}

variable "database_subnet_cidrs" {
  description = "List of database cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
  type        = "list"
  default     = ["172.20.20.0/22", "172.20.24.0/22", "172.20.28.0/22"]
}

variable "availability_zones" {
  description = "List of availability zones you want. Example: ap-southeast-2a, ap-southeast-2b, ap-southeast-2c"
  type        = "list"
  default     = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}

variable "ssh_ip_address" {
  description = "Locks ssh and api access to this IP"
  default     = "0.0.0.0/0"
}

# Database

variable "db_dns_name" {
  default = "database"
}

variable "db_zone" {
  default = "local"
}

variable "db_name" {
  default = "datakube"
}

variable "region" {
  default = "ap-southeast-2"
}

variable "enable_jumpbox" {
  default = false
}

variable "key_name" {
  default = ""
}

variable "db_multi_az" {
  default = false
}

variable "owner" {
  default = "Team name"
}

data "aws_ami" "k8s" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["k8s-1.8-debian-jessie-amd64-hvm-ebs-*"]
  }

  owners = ["383156758163"]
}
