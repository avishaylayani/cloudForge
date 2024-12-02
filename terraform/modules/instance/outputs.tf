output "instance_inventory" {
  value = jsonencode([
    for instance in aws_instance.ec2_machines : {
      name = instance.tags["Name"]
      ip   = instance.public_ip
    }
  ])
}

output "instance_ssh_command" {
  value = join("\n", [
    for instance in aws_instance.ec2_machines : "${instance.tags["Name"]}: ssh -i 'terraform/cloudforge.pem' ubuntu@${instance.public_ip}"
  ])
}

# output "instance_id"{
#   value = aws_instance.ec2_machines.id
# }