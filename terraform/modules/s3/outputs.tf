output "bucket_id" {
  value       = try(aws_s3_bucket.state_bucket[0].id, null)
  description = "S3 bucket ID (if created)"
}
