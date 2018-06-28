#==============================================================
# Database / variables.tf
#==============================================================

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

variable "database_subnet_group" {
  description = "Subnet group for the database"
}

variable "vpc_id" {}

#--------------------------------------------------------------
# Database
#--------------------------------------------------------------

variable "identifier" {
  default     = "mydb-rds"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "180"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type: e.g. mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default {
    postgres = "9.6.6"
  }
}

variable "instance_class" {
  default     = "db.m4.xlarge"
  description = "aws instance"
}

variable "db_name" {
  default     = "mydb"
  description = "Name of the first db"
}

variable "db_username" {
  default = "superuser"
}

variable "rds_is_multi_az" {
  default = false
}

variable "backup_retention_period" {
  # Days
  default = "30"
}

variable "backup_window" {
  # 12:00AM-03:00AM AEST
  default = "14:00-17:00"
}

variable "storage_encrypted" {
  default = false
}

variable "db_port_num" {
  default     = "5432"
  description = "Default port for database"
}

#--------------------------------------------------------------
# Security Groups
#--------------------------------------------------------------

variable "jump_ssh_sg_id" {
  description = "Security group id for the jumpbox"
}

#--------------------------------------------------------------
# Route53 DNS
#--------------------------------------------------------------

variable "dns_name" {
  default     = "database"
  description = "Database url prefix"
}

variable "zone" {
  default     = "local"
  description = "Route53 Zone suffix"
}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "cluster" {}

variable "workspace" {}

variable "owner" {}
