variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Key pair name for the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs for the instances"
  type        = list(string)
}

variable "instance" {
  description = "Names of the instances to create"
  type        = list(string)
}

variable "availability_zone" {
  description = "Availability zone to launch instances"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instances"
  type        = string
}

variable "user_data_script" {
  description = "Path to the script for Micro K8S Installation"
  type        = string
}

variable "username" {
  description = "Username of the instance"
  type        = string
}

variable "private_key_path" {
  description = "value"
  type = string
}