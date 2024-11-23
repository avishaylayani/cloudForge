
resource "aws_key_pair" "ssh_pub" {
  key_name   = "ssh_pub-key"
  public_key = file("technion-key.pub")
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_ebs_volume" "cicd_vol" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    Name = "cicd_vol"
  }
}

resource "aws_instance" "cicd" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_pub.key_name
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0031
    }
  }

  # user_data = file("${path.module}/script.sh")
    user_data = file("script.sh")


  tags = {
    Name = "cicd_server"
  }
}

resource "aws_volume_attachment" "attach_ebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.cicd_vol.id
  instance_id = aws_instance.cicd.id
}

