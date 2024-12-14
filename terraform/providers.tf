provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "main-cloudforge-bucket"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "default" ## Needs to match the AWS profile configured in ~/.aws/config
    # ecnrypt = true ## Can be encrypted in proper environment
  }
}