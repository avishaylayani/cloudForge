output "instance_inventory" {
  value = jsonencode([{
      name = aws_instance.ec2_machines.tags["Name"]
      ip   = aws_instance.ec2_machines.public_ip
  }
  ])
}

output "instance_ssh_command" {
  value = "${aws_instance.ec2_machines.tags.Name}: ssh -i 'filename.pem' user@${aws_instance.ec2_machines.public_ip}"
}

output "instance_id"{
  value = aws_instance.ec2_machines.id
}