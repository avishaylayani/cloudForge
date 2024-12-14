resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket
  tags = {
    Name = var.s3_bucket
  }
  force_destroy = true
}
# resource "aws_s3_bucket_versioning" "enabled" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
  
# }