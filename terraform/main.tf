terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}



# VPC Module
module "vpc" {
  source = "./modules/vpc"

  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  azs          = var.availability_zones

  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs

  tags = var.common_tags
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  node_groups = var.node_groups

  tags = var.common_tags

  depends_on = [module.vpc]
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "csod-node"
}

module "data_bucket" {
  source = "./modules/s3"

  bucket_name = var.data_bucket_name
  versioning  = var.data_bucket_versioning
  tags        = var.common_tags
}

