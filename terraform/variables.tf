variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = "cloudforge"
}

variable "public_key_path" {
  description = "Path to the public key to use for instances"
  type        = string
  default     = "cloudforge.pub"
}

variable "k8s_install_path" {
  description = "Path to the script for Micro K8S Installation"
  type        = string
  default     = "../scripts/microk8s_install.sh"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "cicd_security_group"
}

variable "ami_id" {
  description = "AMI ID for the instance - (default is ubuntu)"
  type        = string
  default     = "ami-0866a3c8686eaeeba"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.medium"
}

variable "instance" {
  description = "Names of the instances to create"
  type        = list(string)
  default     = ["microk8s_master", "microk8s_node_dev", "microk8s_node_prod"]
}

variable "s3_buckets" {
  description = "Names of the buckets to create"
  type        = list(string)
  default     = ["cicd-lajsgfhjkla", "tf-state-lajsgfhjkla"]
}

variable "availability_zone" {
  description = "Availability zone to launch instances"
  type        = string
  default     = "us-east-1a"
}


variable "inventory_filename" {
  description = "Filename for the inventory output"
  type        = string
  default     = "inventory.json"
}

variable "egress_rules" {
  description = "Egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "ingress_rules" {
  description = "Ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 25000
      to_port     = 25000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 19001
      to_port     = 19001
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 16443
      to_port     = 16443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 12379
      to_port     = 12379
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 12380
      to_port     = 12380
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 179
      to_port     = 179
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 6783
      to_port     = 6784
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 6783
      to_port     = 6784
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 5473
      to_port     = 5473
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
