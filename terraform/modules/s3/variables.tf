variable "backend_bucket" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "create_backend_resources" {
  description = "If true, create S3 backend bucket"
  type        = bool
  default     = false
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Tags for S3 bucket"
  type        = map(string)
  default     = {}
}
