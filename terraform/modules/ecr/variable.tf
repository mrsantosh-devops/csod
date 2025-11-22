variable "repository_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "Whether image tags are mutable or immutable"
}

variable "force_delete" {
  type        = bool
  default     = true
  description = "Whether to force delete the repository on destroy"
}

variable "encryption_type" {
  type        = string
  default     = "AES256"
  description = "The encryption type for the repository"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the repository"
}
