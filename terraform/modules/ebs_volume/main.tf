resource "aws_ebs_volume" "ebs_vol" {
  availability_zone = var.availability_zone
  size              = var.ebs_size

  tags = {
    Name = var.ebs_tag_name
  }
}

# Resource to attach the EBS volume to the EC2 instance
resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdf"         # Device name (this can vary depending on the OS, e.g., /dev/sdf, /dev/xvdf)
  volume_id   = aws_ebs_volume.ebs_vol.id       # EBS Volume ID to attach
  instance_id = var.instance_id    # EC2 Instance ID to attach the volume to
}