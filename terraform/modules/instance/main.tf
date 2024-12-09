resource "aws_instance" "ec2_machines" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id

  # associate_public_ip_address = true
  for_each = toset(var.instance)
  # user_data_base64 = base64encode("${templatefile(var.user_data_script)}")
  # user_data = file(var.user_data_script,{
  #   new_hostname = each.value  
  # })
  tags = {
    Name = each.value
  }

  # Set the hostname using remote-exec provisioner
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${each.value}",
      "echo '127.0.0.1 ${each.value}' | sudo tee -a /etc/hosts"
    ]
    connection {
      type        = "ssh"
      user        = var.username 
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}