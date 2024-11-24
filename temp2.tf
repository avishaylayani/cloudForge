provider "aws" {
  region = "us-west-2"  # Update this to your preferred region
}

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "k8s-terraform-state-bucket"
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

terraform {
  backend "s3" {
    bucket = aws_s3_bucket.terraform_state.bucket
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}

resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "k8s_subnet" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  # Update as necessary
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s_security_group"
  description = "Allow inbound traffic for Kubernetes"
  vpc_id      = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allowing Kubernetes API access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s_master" {
  ami                    = "ami-0c55b159cbfafe1f0"  # Update to your preferred Kubernetes AMI
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.k8s_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name               = "your_key_pair"  # Replace with your key pair name

  root_block_device {
    delete_on_termination = true  # Ensure root volume is deleted, no need to manage persistent EBS volumes
  }

  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "k8s_worker" {
  count                  = 2
  ami                    = "ami-0c55b159cbfafe1f0"  # Update to your preferred Kubernetes AMI
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.k8s_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name               = "your_key_pair"  # Replace with your key pair name

  root_block_device {
    delete_on_termination = true  # Ensure root volume is deleted, no need to manage persistent EBS volumes
  }

  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }
}

output "master_public_ip" {
  value = aws_instance.k8s_master.public_ip
}

output "worker_public_ips" {
  value = [for instance in aws_instance.k8s_worker : instance.public_ip]
}

output "private_key_pem" {
  value     = file("private_key")
  sensitive = true
}
