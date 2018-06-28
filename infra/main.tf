module "vpc" {
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.30.0
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.30.0"

  name = "${local.cluster}-vpc"
  cidr = "${var.vpc_cidr}"

  azs              = "${var.availability_zones}"
  public_subnets   = "${var.public_subnet_cidrs}"
  private_subnets  = "${var.private_subnet_cidrs}"
  database_subnets = "${var.database_subnet_cidrs}"

  # Use nat instances instead
  enable_nat_gateway           = false
  create_database_subnet_group = true
  enable_s3_endpoint           = true

  tags = {
    workspace  = "${terraform.workspace}"
    owner      = "${var.owner}"
    cluster    = "${local.cluster}"
    Created_by = "terraform"
  }
}

module "public" {
  source = "modules/public_layer"

  # Networking
  vpc_id                  = "${module.vpc.vpc_id}"
  vpc_igw_id              = "${module.vpc.igw_id}"
  availability_zones      = "${var.availability_zones}"
  public_subnets          = "${module.vpc.public_subnets}"
  public_route_table_ids  = "${module.vpc.public_route_table_ids}"
  private_subnet_cidrs    = "${var.private_subnet_cidrs}"
  private_route_table_ids = "${module.vpc.private_route_table_ids}"

  # Jumpbox
  ssh_ip_address = "${var.ssh_ip_address}"
  key_name       = "${var.key_name}"
  enable_jumpbox = "${var.enable_jumpbox}"
  enable_nat     = true

  # Tags
  owner     = "${var.owner}"
  cluster   = "${local.cluster}"
  workspace = "${terraform.workspace}"
}

module "db" {
  source = "modules/database_layer"

  # Networking
  vpc_id                = "${module.vpc.vpc_id}"
  jump_ssh_sg_id        = "${module.public.jump_ssh_sg_id}"
  database_subnet_group = "${module.vpc.database_subnet_group}"

  dns_name        = "${var.db_dns_name}"
  zone            = "${var.db_zone}"
  db_name         = "${var.db_name}"
  rds_is_multi_az = "${var.db_multi_az}"

  # Tags
  owner     = "${var.owner}"
  cluster   = "${local.cluster}"
  workspace = "${terraform.workspace}"
}

# Create bucket to hold our state
resource "aws_s3_bucket" "kubernetes_state" {
  bucket = "${var.name}"
  acl    = "private"

  tags {
    owner      = "${var.owner}"
    cluster    = "${local.cluster}"
    workspace  = "${terraform.workspace}"
    Created_by = "terraform"
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.name}-tf"
  acl    = "private"

  tags {
    owner      = "${var.owner}"
    cluster    = "${local.cluster}"
    workspace  = "${terraform.workspace}"
    Created_by = "terraform"
  }
}
