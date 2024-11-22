
provider "aws" {
  region = "us-east-1"
}

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "tfstate-cloudforge"  
#   force_destroy = true           

#   tags = {
#     Name = "Terraform State Bucket"
#   }
# }

# terraform {
#   backend "s3" {
#     bucket         = "tfstate-cloudforge"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#   }
# }

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("technion-key.pub")
}

resource "aws_instance" "app_server" {
  ami           = "ami-064519b8c76274859"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  for_each      = toset(["vm.one", "vm.two", "vm.three"])

  tags = {
    Name = "MyDebianAppServer.${each.key}"
  }
}

