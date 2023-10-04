# S3 bucket to store App
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tokyo-tf-state"
# Prevent accidental deletion of this S3 bucket
 lifecycle {
    prevent_destroy = false
  }
}
# Enable versioning so you can see the full revision history of your
# state files
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# Upload TF state file to S3 bucket
#resource "aws_s3_object" "object" {
#  bucket = "tokyo-tf-state"
#  key    = "httpd.sh" # Object name
#  source = "./scripts/install-httpd.sh"
#  lifecycle {
#    prevent_destroy = false
#  }
#}