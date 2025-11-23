terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-node-csod"
    key    = "csod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
