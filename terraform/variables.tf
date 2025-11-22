variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "prod-eks"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.64.0/19", "10.0.96.0/19"]
}

variable "node_groups" {
  description = "EKS node groups configuration"
  type = map(object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
    capacity_type  = string
    disk_size      = number
    labels         = map(string)
  }))
  default = {
    general = {
      desired_size   = 1
      max_size       = 2
      min_size       = 1
      instance_types = ["m4.xlarge"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 128
      labels = {
        role = "general"
      }
    }
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "csod"
    ManagedBy   = "terraform"
  }
}

variable "backend_bucket" {
  description = "S3 bucket to store Terraform backend state"
  type        = string
}

variable "backend_key" {
  description = "S3 key (path) for Terraform state file"
  type        = string
  default     = "terraform.tfstate"
}

variable "create_backend_resources" {
  description = "If true, S3 bucket will be created (bootstrap run)"
  type        = bool
  default     = false
}
