variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Names of the buckets to create"
  type        = string
  default     = "main-cloudforge-bucket"
}

variable "bucket_tags" {
  description = "Tags to assign to the S3 bucket"
  type        = map(string)
  default = {
    Name = "Terraform Cloudforge Bucket"
  }
}
