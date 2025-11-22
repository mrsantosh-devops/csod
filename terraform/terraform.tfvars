cluster_name    = "prod-eks"
cluster_version = "1.32"
aws_region      = "us-east-1"

common_tags = {
  Environment = "production"
  Project     = "csod"
  ManagedBy   = "terraform"
  Owner       = "devops"
}
