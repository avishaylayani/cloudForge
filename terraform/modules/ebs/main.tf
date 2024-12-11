resource "aws_ebs_volume" "postgres_ebs" {
  availability_zone = "us-east-1a"
  size              = 10
  type = "io1"
  iops = 200
  tags = {
    Name = "postgres_ebs"
  }
  multi_attach_enabled = true
}

resource "aws_volume_attachment" "ebs" {
  device_name = "/dev/sdh"
  volume_id = aws_ebs_volume.postgres_ebs.id
  count = length(var.instance_id)
  instance_id = element(var.instance_id, count.index)
}