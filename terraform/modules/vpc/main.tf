resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # Create a subnet within the VPC range
  availability_zone       = var.availability_zone

  tags = {
    Name = "main_subnet"
  }
}