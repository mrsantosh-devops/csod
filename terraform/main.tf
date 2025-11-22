terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-node-csod" # replace with your bucket name
    key     = "csod/terraform.tfstate"           # path inside the bucket
    region  = "us-east-1"                        # your AWS region
    encrypt = true                               # encrypt the state at rest
  }
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

# S3 backend bootstrap module (creates S3 bucket only)
module "backend_bootstrap" {
  source = "./modules/s3"

  backend_bucket           = var.backend_bucket
  region                   = var.aws_region
  tags                     = var.common_tags
  create_backend_resources = var.create_backend_resources
}

