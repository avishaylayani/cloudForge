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

# output "instances_id" {
#   value = [for id in aws_instance.ec2_machines : id.id]
#   description = "List of all EC2 instance IDs"
# }

output "master_id"{
  description = "Will be used by ebs module, to attach another disk for PV in k3s"
  value = [for id in aws_instance.ec2_machines : id.id if id.tags["Name"] == "k3s-master"]
}

# output "instance_id"{
#   value = aws_instance.ec2_machines.id
# }