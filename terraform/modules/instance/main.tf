resource "aws_instance" "ec2_machines" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  # associate_public_ip_address = true


  for_each = toset(var.instances)

  tags = {
    Name = each.value
  }
}