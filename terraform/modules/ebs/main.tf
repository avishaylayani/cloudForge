resource "aws_ebs_volume" "cicd" {
  availability_zone = "us-east-1a"
  size              = 3
  tags = {
    Name = "cicd"
  }
}

resource "aws_volume_attachment" "ebs" {
  device_name = "/dev/sdh"
  volume_id = aws_ebs_volume.cicd.id
  instance_id = var.instance_id
}