output "instance_ssh_command" {
  description = "The SSH commands for all instances."
  value       = module.instance.instance_ssh_command
}

output "instances_id" {
  description = "Instances IDs"
  value       = module.instance.instances_id
}