resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  tags          = var.bucket_tags
  force_destroy = true
}