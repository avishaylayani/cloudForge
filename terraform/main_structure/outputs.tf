output "instance_ssh_command" {
  description = "The SSH commands for all instances."
  value       = module.instance.instance_ssh_command
}

output "master_id" {
  description = "Instances IDs"
  value       = module.instance.master_id
}
