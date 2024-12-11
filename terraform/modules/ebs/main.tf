resource "aws_ebs_volume" "postgres_ebs" {
  availability_zone = "us-east-1a"
  size              = 10
  type = "gp3"
  tags = {
    Name = "postgres_ebs"
  }
}

resource "aws_volume_attachment" "ebs" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.postgres_ebs.id
  instance_id = var.master_id
}