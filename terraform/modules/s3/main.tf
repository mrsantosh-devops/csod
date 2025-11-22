resource "aws_s3_bucket" "state_bucket" {
  count  = var.create_backend_resources ? 1 : 0
  bucket = var.backend_bucket
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.tags, { Name = var.backend_bucket })
}
