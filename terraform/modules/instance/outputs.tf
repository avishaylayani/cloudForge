output "instance_inventory" {
  value = jsonencode([
    for instance in aws_instance.ec2_machines : {
      name = instance.tags["name"]
      ip   = instance.public_ip
    }
  ])
}

output "instance_ssh_commands" {
  value = join("\n", [
    for instance in aws_instance.ec2_machines : "${instance.tags["name"]}: ssh -i 'filename.pem' user@${instance.public_ip}"
  ])
}